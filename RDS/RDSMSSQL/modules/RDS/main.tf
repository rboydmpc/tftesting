# Assign null values to empty string to make conpact() work

locals {
  var_iops = {
    value = var.storage_type == "io1" ? max(var.iops, var.max_allocated_storage) : null
  }
}
