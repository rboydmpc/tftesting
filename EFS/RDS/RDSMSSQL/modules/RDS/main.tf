# Assign null values to empty string to make conpact() work


#locals {
#  vpc_subnet_az1 = length(regexall("^subnet", var.vpc_subnet_az1)) > 0 ? var.vpc_subnet_az1 : ""
#  vpc_subnet_az2 = length(regexall("^subnet", var.vpc_subnet_az2)) > 0 ? var.vpc_subnet_az2 : ""
#}

locals {
  #Conditionally set the iops value.
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

var_iops = {
    value = var.storage_type == "io1" ? max(var.iops, var.max_allocated_storage*0.5) : null
  }
resource "aws_db_subnet_group" "group" {
  name       = format("%s-sngrp", lower(var.db_name))
  subnet_ids = local.var_az_subnets.value
  
  lifecycle {
    ignore_changes = [
      tags["Date"],
    ]
  }
  tags = {
    Author = "Effectual Terraform script"
    Date = "${local.time}"
  }
  
}

data "aws_subnet" "this_subnet" {
  id = var.vpc_subnet_az1
}

data "aws_vpc" "selected" {
  id = "${data.aws_subnet.this_subnet.vpc_id}"
}

resource "aws_security_group" "db_sg" {
  name        = format("%s_rds-sg", lower(var.db_name))
  description = "${var.db_name} Database security group"
  vpc_id      = data.aws_subnet.this_subnet.vpc_id
  ingress {
    description = "Port for RDS Oracle Database"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_db_instance" "new_db" {
  identifier                  = lower(var.db_name)
  name                        = null #lower(var.db_name)
  multi_az                    = var.multi_az
  availability_zone           = var.multi_az == true ? null : join("", [var.region, "a"])
  allocated_storage           = local.var_storage.value     #"${var.allocated_storage}"
  max_allocated_storage       = var.max_allocated_storage
  storage_type                = var.storage_type
  iops                        = local.var_iops.value
#  storage_encrypted           = true
  port                        = var.db_port
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  maintenance_window          = var.maintenance_window
  copy_tags_to_snapshot       = true
  #monitoring_interval         = 1
  #monitoring_role_arn         = aws_iam_role.rds_iam_role.arn
  #enabled_cloudwatch_logs_exports = ["agent", "error"] 
  engine                      = var.engine_name
  engine_version              = var.engine_version
  #character_set_name          = var.character_set_name
  instance_class              = var.instance_class
  db_subnet_group_name        = aws_db_subnet_group.group.id
  vpc_security_group_ids      = ["${aws_security_group.db_sg.id}"]
  publicly_accessible         = false
  allow_major_version_upgrade = false
  apply_immediately           = var.apply_immediately
  auto_minor_version_upgrade  = false
  deletion_protection         = false
  delete_automated_backups    = true
  parameter_group_name        = aws_db_parameter_group.default.id
  option_group_name           = aws_db_option_group.db_group.name
  username                    = lower(var.db_name)    
  password                    = var.password
  skip_final_snapshot         = true
  final_snapshot_identifier   = "rds-${var.db_name}-final-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  license_model               = "license-included"
  snapshot_identifier         = var.snapshot_id
  

         
  timeouts {
     create = "240m"
  }
}

/**
  Parameter Group
*/
resource "aws_db_parameter_group" "default" {
  name        = lower("${var.db_name}-${formatdate("YYYY-MM-DD-hhmm", timestamp())}-pg")
  description = format("Parameter group for %s", var.db_name)
  family      = var.family

  

}

/**
  Options group
*/
resource "aws_db_option_group" "db_group" {
  name                     = lower("${var.db_name}-${formatdate("YYYY-MM-DD-hhmm", timestamp())}-og")
  option_group_description = format("Option group for %s", var.db_name)
  engine_name              = var.engine_name
  major_engine_version     = var.major_engine_version
}
  
