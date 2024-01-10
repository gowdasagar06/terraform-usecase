Step 1. Terraform State file should be stored in backend storage  and lock the state file to prevent from multiple writes at sametime 
Step 2. Launch a Ec2 instance (may be  debian / fedora based ) install nginx in the Ec2 instance without passing userdata in the EC2 terraform block create the PEM key through the Terraform code 
        Spec : Attach it with Security Group , EBS Volume ( should be KMS key encrypted ) , Instance should be attached with EIP ( Elastic IP Address ) , while creating security group use the dyanmic blocks. 
Step 3 : Need the Ouput File and Outputs 
3.1 In the outputs.tf file need all the outputs from above code when you excute the code outputs shoule be print in the CLI 
3.2 Outputs ( all the required endpoints ) also to  be stored in the output.txt file 
