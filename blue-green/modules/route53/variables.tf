variable "zone_id" {
  description = "input variable for ID of hosted zone to contain this record"
}

variable "record_name" {
  description = "input variable for record name"
}

variable "record_type" {
  description = "input variable for record type"
}

variable "cname_ttl" {
  description = "input variable for ttl"
}

variable "cname_records" {
  description = "input variable for records"
}
