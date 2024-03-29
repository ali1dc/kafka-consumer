@cloudformation = MinimalPipeline::Cloudformation.new
@keystore = MinimalPipeline::Keystore.new
@docker = MinimalPipeline::Docker.new

ENV['AWS_REGION'] = 'us-east-1'
@port = '8090'

@ecs_repo_name = 'xsp-kafka-consumer'
docker_repo = @keystore.retrieve('ECR_REPOSITORY')
@docker_image = "#{docker_repo}/#{@ecs_repo_name}:latest"

def get_subnets(subnet_cluster)
  subnet_cluster.upcase!
  subnet1 = @keystore.retrieve("#{subnet_cluster}_SUBNET_1")
  subnet2 = @keystore.retrieve("#{subnet_cluster}_SUBNET_2")
  subnet3 = @keystore.retrieve("#{subnet_cluster}_SUBNET_3")
  [subnet1, subnet2, subnet3].join(',')
end
