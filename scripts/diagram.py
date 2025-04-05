# diagram.py
from diagrams import Diagram
from diagrams.aws.network import VPC, InternetGateway, NATGateway, RouteTable, ALB
from diagrams.aws.compute import EC2, AutoScaling
from diagrams.aws.network import PrivateSubnet, PublicSubnet
from diagrams.aws.security import Shield
from diagrams.aws.database import RDS

with Diagram("AWS VPC Infrastructure", show=False, filename="architectural_diagram", outformat="png", direction="TB"):
    # Define VPC components
    vpc = VPC("VPC")
    igw = InternetGateway("Internet Gateway")
    nat = NATGateway("NAT Gateway")
    rt_public = RouteTable("Public Route Table")
    rt_private = RouteTable("Private Route Table")
    
    # Define subnets with AZ information in labels
    public_subnet1 = PublicSubnet("Public Subnet\n(us-east-1a)")
    public_subnet2 = PublicSubnet("Public Subnet\n(us-east-1b)")
    private_subnet1 = PrivateSubnet("Private Subnet\n(us-east-1a)")
    private_subnet2 = PrivateSubnet("Private Subnet\n(us-east-1b)")
    
    # Define ALB
    alb = ALB("Application\nLoad Balancer")
    
    # Define Auto Scaling Group
    asg = AutoScaling("Auto Scaling\nGroup")
    
    # Define EC2 instances
    ec2_public = EC2("Public EC2")
    
    # Define RDS instances
    rds_primary = RDS("RDS Primary")
    rds_replica = RDS("RDS Replica")
    
    # Define security groups using Shield icon
    sg_public = Shield("Public SG")
    sg_private = Shield("Private SG")
    sg_rds = Shield("RDS SG")
    
    # Define relationships with proper flow
    # Internet Gateway to VPC
    igw - vpc
    
    # VPC to Subnets
    vpc - [public_subnet1, public_subnet2]
    vpc - [private_subnet1, private_subnet2]
    
    # Public Subnets to NAT Gateway
    public_subnet1 - nat
    public_subnet2 - nat
    
    # NAT Gateway to Private Subnets
    nat - private_subnet1
    nat - private_subnet2
    
    # Route Tables to Subnets
    rt_public - [public_subnet1, public_subnet2]
    rt_private - [private_subnet1, private_subnet2]
    
    # ALB to Public Subnets
    alb - [public_subnet1, public_subnet2]
    
    # Auto Scaling Group to Private Subnets
    asg - [private_subnet1, private_subnet2]
    
    # Security Groups to Resources
    sg_public - ec2_public
    sg_private - asg
    sg_rds - [rds_primary, rds_replica]
    
    # Subnets to Resources
    public_subnet1 - ec2_public
    private_subnet1 - rds_primary
    private_subnet2 - rds_replica
    
    # RDS Replication
    rds_primary - rds_replica