# diagram.py
from diagrams import Diagram
from diagrams.aws.network import VPC, InternetGateway, NATGateway, RouteTable
from diagrams.aws.compute import EC2
from diagrams.aws.network import PrivateSubnet, PublicSubnet
from diagrams.aws.security import Shield

with Diagram("AWS VPC Infrastructure", show=False, filename="architectural_diagram", outformat="png", direction="TB"):
    # Define VPC components
    vpc = VPC("VPC")
    igw = InternetGateway("Internet Gateway")
    nat = NATGateway("NAT Gateway")
    rt_public = RouteTable("Public Route Table")
    rt_private = RouteTable("Private Route Table")
    
    # Define subnets with AZ information in labels
    public_subnet1 = PublicSubnet("Public Subnet\n(AZ-1)")
    public_subnet2 = PublicSubnet("Public Subnet\n(AZ-2)")
    private_subnet1 = PrivateSubnet("Private Subnet\n(AZ-1)")
    private_subnet2 = PrivateSubnet("Private Subnet\n(AZ-2)")
    
    # Define EC2 instances
    ec2_public = EC2("Public EC2")
    ec2_private = EC2("Private EC2")
    
    # Define security groups using Shield icon
    sg_public = Shield("Public SG")
    sg_private = Shield("Private SG")
    
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
    
    # Security Groups to EC2 instances
    sg_public - ec2_public
    sg_private - ec2_private
    
    # Subnets to EC2 instances
    public_subnet1 - ec2_public
    private_subnet1 - ec2_private