module "mod_rds" {
    source      = "./modules/RDS/"

    #inputs:
    access_key              = var.access_key
    secret_key              = var.secret_key
    instance_class          = var.instance_class
    environment             = var.environment
    region                  = var.region
    multi_az                = var.multi_az
    vpc_subnet_az1          = var.vpc_subnet_az1
    vpc_subnet_az2          = var.vpc_subnet_az2
    family                  = var.family
    engine_name             = var.engine_name
    major_engine_version    = var.major_engine_version
    engine_version          = var.engine_version
    db_name                 = lower(var.db_name)
    db_port                 = var.db_port
    allocated_storage       = var.allocated_storage
    max_allocated_storage   = var.max_allocated_storage
    storage_type            = var.storage_type
    iops                    = var.iops
    character_set_name      = var.character_set_name
    apply_immediately       = var.apply_immediately
    password                = var.password
}

