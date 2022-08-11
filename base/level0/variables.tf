variable "bucket_folders" {
  type        = list(string)
  description = "These folders will be used to hold the state files for the different layers"

}

variable "env" {
  description = "variable for environment"
}
