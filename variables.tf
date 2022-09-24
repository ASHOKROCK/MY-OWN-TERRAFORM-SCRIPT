variable "myvpc-cidr" {
 description = "This is New Subnet Range"
 type        =  string
 default     = "10.80.0.0/16"
}

variable "mysub-cidr" {
 description = "This is New Subnet Range"
 type        =  list
 default     = ["10.80.1.0/24","10.80.2.0/24","10.80.3.0/24"]
}

variable "newtenancy" {
 description = "This is New Subnet Range"
 type        =  string
 default     = "default"
}

variable "myownbucket" {
 description = "This is own my bucket Name"
 type        =  string
 default     = "mynewthirdcustombucket"
}

variable "myname" {
 description = "This is New BUcket Name"
 type        =  string
 default     = "MYNEWCUSTOMVPC-SG"
}

/*variable "azs" {
  description = "This is New BUcket Name"
  type        =  list
  default     = ["us-east-1a","us-east-1b","us-east-1c"]
}*/

data aws_availability_zones "azs" {}

variable "myregion" {
  description = "This is New BUcket Name"
  type        =  string
  default     = "us-east-1"
}

