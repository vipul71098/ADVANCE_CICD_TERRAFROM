output "ebs_volume_id" {
  value       = module.ebs_volume.volume_id
}


output "ebs_size" {
  value       = var.ebs_size
}

output "ebs_type" {
  value       = var.ebs_type
}



output "key_node_ebs" {
   value    =  var.key_node_ebs
}
