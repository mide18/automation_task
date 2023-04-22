## Containerised application deployed on AWS on infrastructure using GitHub Action

<img width="1420" alt="Screenshot 2023-04-22 at 09 36 48" src="https://user-images.githubusercontent.com/43912867/233779073-d7f86ac1-1f52-4428-8926-949b15d2afd9.png">


## Tools used
    * Node.js: This is used to develop the Hello World! App.​
    * Terraform: Used to provision the EC2 instance used to deploy the application on AWS​
    * Github: Used to store the application remotely​
    * Github-Action: To automate the all process from provisioning of infrastructure to deploying a container. ​
    * Docker: Use to containerise, build, push image and deploy docker image to EC2​
    * Amazon Web Services (AWS): Public cloud used to host the application
## Steps to deploy a containerized application on AWS

*  Developed a simple nodejs app name "app.js" listening on port 8080​

* Write a dockerfile for the app.js application​

* From the AWS console: ​

    * get the access key ID and sercret ID from the IAM user​

    * Create the S3 bucket to store the terraform state file remotely ​

* Generate SSH keys to connect to EC2 using 'ssh-keygen'​

* Write a terraform script to provision EC2 instance and store the terraform state remotely.​ This can be seen in the terraform directory in the repo.

* Write a CI/CD pipeline that will automate the provisioning and deployment of the docker container. This can be found in the ".github/workflows/main.yml" directory

### CONCLUSION
In conclusion, I decided automate this whole process from the provisioning to deployment of the docker container beacuse it's the standrad and best practice which saves alot of time to deliver applications and services at high velocity . This enables DevOps Engineers to focus on solving other problems while Developers can continuosly working on the app improvement as well as easy bug and security fixes.
