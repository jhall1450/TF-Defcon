variable "dedcon_server_name" {
  type = string
}

variable "dedcon_server_port" {
  type    = number
  default = 5010
}

variable "dedcon_server_key" {
  type      = string
  sensitive = true
}

variable "dedcon_gamemode" {
  type    = number
  default = 0
}

variable "dedcon_max_players" {
  type    = number
  default = 4
}

variable "dedcon_territories_per_player" {
  type    = number
  default = 1
}

variable "dedcon_cities_per_territory" {
  type    = number
  default = 25
}

variable "dedcon_population_per_territory" {
  type    = number
  default = 100
}

variable "dedcon_city_population_mode" {
  type    = number
  default = 0
}

variable "dedcon_random_territories" {
  type    = number
  default = 0
}

variable "dedcon_score_mode" {
  type    = number
  default = 0
}
