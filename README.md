# ACS Networking


### Run
WARN: Before starting create an S3 bucket and update the bucket name in [here.](./provider.tf#L12)

#### Create VPC, Subnets & EC2s
```bash
make tf-plan
make tf-apply
```

#### Hop into EC2s
```bash
# change private key permissions (required)
chmod 400 awsnetblog_vpc_01-privatekey_01.pem
# copy file to our public subnet EC2 (we need the key on that machine)
scp -i awsnetblog_vpc_01-privatekey_01.pem awsnetblog_vpc_01-privatekey_01.pem ubuntu@54.187.77.242:/home/ubuntu/
# ssh into public subnet EC2!
ssh -v -i awsnetblog_vpc_01-privatekey_01.pem ubuntu@54.187.77.242

# ssh from public subnet EC2 to our private subnet EC2!
ssh -v -i /home/ubuntu/awsnetblog_vpc_01-privatekey_01.pem ubuntu@10.1.2.156
```

#### Cleanup
```bash
make tf-destroy-plan
make tf-destroy-apply
```
