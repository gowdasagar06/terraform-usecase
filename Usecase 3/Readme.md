
1. Create a AutoScaling Group ,  Define Autoscaling Policies and Associate them to Autoscaling Group 
2. Create Target Group , NLB --> Should be HA ( high available ) and deletion protection enabled , access logs should be enabled and stored 
3. Create launch template pass the user data to install apache httpd server and start the service and run it in Ec2 instnace so that UI can be accessble  , attach an EBS volume to it. 
4. Need the Ouput File and Outputs 
5. In the outputs.tf file need all the outputs from above code when you excute the code outputs shoule be print in the CLI 
6.Outputs ( all the required endpoints ) also to  be stored in the output.txt file 
