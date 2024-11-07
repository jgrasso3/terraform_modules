variable "bucket-name" {
  type = string
  default = "aws-test"
}

variable "static-files" {
  type = string
  default = "/home/jgrasso1/Learn/angular/projects/aws-test/dist/aws-test/browser"
}

variable "block-public-access" {
  type = bool
  default = false
}
