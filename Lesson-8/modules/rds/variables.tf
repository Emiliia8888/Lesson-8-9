variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "use_aurora" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "engine" {
  type    = string
  default = "postgres"
}

# Змінено з 15.4 на 15, щоб AWS сам обрав актуальну мінорну версію
variable "engine_version" {
  type    = string
  default = "15.17"
}

variable "instance_class" {
  type    = string
  default = "db.t4g.medium"
}

variable "parameter_group_family" {
  type    = string
  default = "postgres15"
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type    = number
  default = 5432
}
