variable "environment" {
  default = "dev"

}

variable "rg_location" {
  default = "East Asia"

}

variable "vm_size" {
  default = "Standard_B2ms"

}
variable "vmss_size" {
  default = "Standard_B1s"

}

variable "pub_key" {
  type        = string
  description = "public key for vm ssh access"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDERT8JttlolL0H4AwAnOaOvebDim0hq5GiCM3cF8/37t4EDgmtXeYibf9jGZNy26pLwXmA56VL0cX4QzLAFAcQx0kSyQzfvJOK724Nx2PhWI3q/ZwzTjXoqulVuu0HwpbswpGaztJIRxXpfQvcBzF6QG1PYQeMbd/FmqYTb3z3xswHam/jj1duRbE8uKZuwphmFDwegbILa02zzqhYLs5WhiPjLmbWF9hmPhRWNnvokKes8ME4pI30d2tsOjKSM311ieF7B/hMdTBr+yh5UEqxP8uAGXkwAklRSab5tDnqtbf17jINJG6qz3kXZYHVedpP8aTcDqha6ACBNHZLofVNGfQsRFxIkf0XajMAabWVUnpt/n1KBfF7L2Tnty3//9p5A4n6zeO4bLWsK5utitOZ5+T1qfKQo2cBDmZkfdYFpoSc5yDQo3Yr31W93tDsAK01hVQbsOuOeu5Wr7QfZ8zTG+/g8anBJHWgR5qHpETxxU00usNCuhyO9G/h1c8QPi8= root@INHL1250"

}

variable "gituser" {
  default = "amars"

}

variable "gitpass" {
  default = ""

}

variable "email" {
  default = "amars@interrait.com"

}
