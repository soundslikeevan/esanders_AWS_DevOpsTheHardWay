variable "bucket_name" {
    type = string
    default = "terraform-state-esanders-devopsthehardway"
}
variable "key" {
    type = string
    default = "eks-terraform-workernodes.tfstate"
}
variable "region" {
    type = string
    default = "ap-southeast-2"
}
variable "subnet_id_1" {
    type = string
    default = "subnet-090b461cc7b604ed6"
}
variable "subnet_id_2" {
    type = string
    default = "subnet-01d920bc5c6939e0a"
  
}
