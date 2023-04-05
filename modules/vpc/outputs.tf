output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
    value = aws_subnet.public.*.id
}

output "cidr_block" {
    value = aws_vpc.cidr_block.id
}