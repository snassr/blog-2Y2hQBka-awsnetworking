# ACS Networking


## Testing EC2s
```bash
chmod 400 awsnetblog_vpc_01-privatekey_01.pem
ssh -v -i awsnetblog_vpc_01-privatekey_01.pem ubuntu@54.187.77.242
scp -i awsnetblog_vpc_01-privatekey_01.pem awsnetblog_vpc_01-privatekey_01.pem ubuntu@54.187.77.242:/home/ubuntu/

# ssh from public to private
ssh -v -i /home/ubuntu/awsnetblog_vpc_01-privatekey_01.pem ubuntu@10.1.2.156
```
