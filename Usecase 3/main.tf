provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.az_names[count.index]

  tags = {
    Name = join("-", [var.public_subnet_name, var.az_names[count.index]])
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.az_names[count.index]

  tags = {
    Name = join("-", [var.private_subnet_name, var.az_names[count.index]])
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  
    tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_eip" "elastic_ip" {
  tags = {
    Name = var.elastic_ip_name
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id     = aws_eip.elastic_ip.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_subnet[0].id

  tags = {
    Name = var.nat_gateway_name
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  
    tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}


resource "aws_security_group" "alb_security_group" {
  name        = var.alb_security_group_name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb_security_group_name
  }
}

resource "aws_security_group" "asg_security_group" {
  name        = var.asg_security_group_name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.asg_security_group_name
  }
}



resource "aws_launch_template" "launch_template" {
  name          = var.launch_template_name
  image_id      = var.ami
  instance_type = var.instance_type

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg_security_group.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
    Name = var.launch_template_ec2_name
    }
  }

 user_data = filebase64("./install-apache.sh")
}

resource "aws_autoscaling_group" "auto_scaling_group" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = [for i in aws_subnet.private_subnet[*] : i.id]
  target_group_arns   = [aws_lb_target_group.target_group.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
}
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [for i in aws_subnet.public_subnet : i.id]
}

resource "aws_lb_target_group" "target_group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}


resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_scaling_group.name}"
}
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "70"
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_scaling_group.name}"
  }
alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.web_policy_up.arn}" ]
}
resource "aws_autoscaling_policy" "web_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.auto_scaling_group.name}"
}
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.auto_scaling_group.name}"
  }
alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.web_policy_down.arn}" ]
}