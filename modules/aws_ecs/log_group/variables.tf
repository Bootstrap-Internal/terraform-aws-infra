variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "retention_in_days" {
  description = "Time period fro log group retention"
  type        = number
}