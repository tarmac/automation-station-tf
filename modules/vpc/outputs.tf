output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
    value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
    value = aws_subnet.private.*.id
}

output "cidr_block" {
    value = aws_vpc.vpc.cidr_block
}
output "subnet_private_cidr" {
  description = "Private subnets cidr block"
  value       = aws_subnet.private.*.cidr_block
}

output "subnet_public_cidr" {
  description = "Private subnets cidr block"
  value       = aws_subnet.public.*.cidr_block
}