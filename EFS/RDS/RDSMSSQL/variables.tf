/**
    Providers variables
*/
variable "region" {
  description = "Region where the resources will be created"
  type        = string 
  default = "us-east-1"
}

variable "access_key"{
  description = "Access Key"
  type        = string 
}

variable "secret_key" {
  description = "Secret Key"
  type        = string 
}

/**
    Generic variables
*/

variable "environment"{
  description = "Environment"
  type        = string 
  default     = "PRD"
}

/***
    Variables required to create a secret
**/

/**
    Variables required to create the Security Group, IAM Role and Policy    
*/
variable "vpc_subnet_az1"{
  description = "ID of the VPC subnet in the 1st Availability Zone"
  type        = string
  default     = "subnet-47f3be21"
}

variable "vpc_subnet_az2"{
  description = "ID of the VPC subnet in the 2nd Availability Zone"
  type        = string  
  default     = "subnet-6637a757"
}


/***
    Variables required to create a parameter group
**/
variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "sqlserver-se-15.0"
}

/***
    Variables required to create an options group
**/
variable "engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with"
  type        = string
  default     = "sqlserver-se"
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "15.00"
}

/***
    Variables required to create a subnet group
**/


/***
    Variables required to create an instance
**/

variable "db_name"{
  description = "Name of the new database, must be provided"
  type        = string 
}

variable "db_port"{
  description = "The port on which the DB accepts connections"
  type        = string
  default     = "1433"
}

variable "multi_az" {
  description = "Deploy to multiple availability zones"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number #string?
  default     = 500
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 1000
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "15.00.4043.16.v1"
}

variable "character_set_name" {
  description = "(Optional) The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS for more information"
  type        = string
  default     = "AL32UTF8"
}

variable "instance_class"{
  description = "Type of instance"
  type        = string 
  default     = "db.m5.4xlarge" #"db.t3.small" #"db.m5.xlarge" 
}

variable "storage_type" {
  description = "Must be 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  type        = string
  default     = "gp2"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'."
  type    = number
  default = 0   # @TODO use null as default when Morpheus UI can support
}


#     Instance backup & maintenance options
variable "backup_window" {
  description = "Backup window (times)"
  type        = string
  default     = "20:00-21:00"
}

variable "backup_retention_period" {
  description = "Number of days to keep a backup"
  type        = number
  default     = 35
}

variable "maintenance_window" {
  description = "Day(s) when maintenance will take place"
  type        = string
  default     = "Fri:22:00-Fri:23:00"
}

variable "apply_immediately" {
  description = "apply changes immediately do not wait for maintenance window "
  type        = string
  default     = "false"
}

variable "password"{
  description = "DB Password"
  type        = string 
}
