from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2, ApplicationAutoScaling

with Diagram("AWS Spot Fleet", show=False, direction="TB"):

    with Cluster("vpc"):

        EC2("spot ec2 instances 0..n") << [ApplicationAutoScaling("scale out"), ApplicationAutoScaling("scale in")]
