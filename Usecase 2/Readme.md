PreRequisites : Terraform State file should be stored in backend storage  and lock the state file to prevent from multiple Dynamo DB should be created from the code writes at same time  
Step 1 : Create a VPC with 9 subnets in 3AZ's each subnet should be in each AZ VPC CIDR Range : 10.0.0.0/16
        1. data base subnets -> 3 pvt subnets ( dbsubnet1, dbsubets2, dbsubnet3 ) 
        2. Pvt Subnets --> 3 pvt subnets ( pvtsubnet1 , pvtsubnet2 , pvtsubnet3 ) 
        3. PublicSubnet --> 3 public Subnets ( pubsubnet1 , pubsubnet2 , pubsubnet3 ) 
        4. Enable VPC flow logs 
        5. need the subnetsid , arns , cidr ranges of subnets , vpc id in the outputs section 
