from aws_cdk import (
    aws_autoscaling as autoscaling,
    aws_ec2 as ec2,
    aws_elasticloadbalancingv2 as elbv2,
    core as cdk,
)

from python_terraform import *

class cloudlearning9AppstackStack(cdk.Stack):

    def __init__(self, scope: cdk.Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Create Cloud Learning 9 VPC
        # CloudLearningCIDRBlock = "10.3.0.0/16"
        # self.vpcCloudLearning = ec2.Vpc(self, "CloudLearningVPC",
        #                                 max_azs=2,
        #                                 cidr=CloudLearningCIDRBlock,
        #                                 # configuration will create 1 group in 2 AZs = 2 subnet.
        #                                 subnet_configuration=[ec2.SubnetConfiguration(
        #                                     subnet_type=ec2.SubnetType.PUBLIC,
        #                                     name="Public",
        #                                     cidr_mask=24,
        #                                 )
        #                                 ],
        #                                 nat_gateways=0,
        #                                 )
        terraformVPC = Terraform(working_dir='../terraformVPC')
        terraformVPC_output = terraformVPC.output()
        vpc_id = terraformVPC_output['vpc_id']['value']

        self.vpcCloudLearning = ec2.Vpc.from_lookup(self, "VPC",
                                                    vpc_id=vpc_id
                                                    )

        data = open("./UserData.sh", "rb").read()
        userdata = ec2.UserData.for_linux()
        userdata.add_commands(str(data, 'utf-8'))

        asg = autoscaling.AutoScalingGroup(
            self,
            "AutoScalingGroup",
            vpc=self.vpcCloudLearning,
            instance_type=ec2.InstanceType.of(
                ec2.InstanceClass.BURSTABLE2, ec2.InstanceSize.MICRO
            ),
            min_capacity=2,
            max_capacity=3,
            machine_image=ec2.AmazonLinuxImage(generation=ec2.AmazonLinuxGeneration.AMAZON_LINUX_2),
            user_data=userdata,
            update_policy=autoscaling.UpdatePolicy.replacing_update() # this update_policy replaces default rolling updates
        )

        lb = elbv2.ApplicationLoadBalancer(
            self, "LB",
            vpc=self.vpcCloudLearning,
            internet_facing=True)

        listener = lb.add_listener("Listener", port=80)
        listener.add_targets("Target", port=80, targets=[asg])
        listener.connections.allow_default_port_from_any_ipv4("Open to the world")

        asg.scale_on_request_count("AModestLoad", target_requests_per_second=1)
        cdk.CfnOutput(self, "CloudLearning9-LoadBalancer", export_name="CloudLearning9-LoadBalancer",
                      value=lb.load_balancer_dns_name)
