# Assign null values to empty string to make conpact() work

locals {
  var_iops = {
    value = var.storage_type == "io1" ? max(var.iops, var.max_allocated_storage*0.5) : null
  }
  var_storage = {
    value = max(var.allocated_storage, (var.max_allocated_storage*0.02))
  }
  var_az_subnets = {
    value = compact([local.vpc_subnet_az1, local.vpc_subnet_az2])
  }
  time = "${timestamp()}"
  
}
