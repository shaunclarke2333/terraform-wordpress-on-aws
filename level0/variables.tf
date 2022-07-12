variable "bucket_folders" {
  type        = list(string)
  description = "These folders will be used to hold the state files for the different layers"
  default = [
    "level0/",
    "level1/",
    "level2/",
    "level3/"
  ]
}
