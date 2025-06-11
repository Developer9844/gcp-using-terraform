# output "bucket_name" {
#   value = module.storageBucket.bucket_name
# }

output "public_subnet_name" {
  value = module.vpc.public_subnet_name
}

# output "forward_ip-load_balancer" {
#   value = module.load_balancer.forwarding_ip
# }

output "global_ip" {
  value = module.cdnBucketStaticWebsite.global_ip
}