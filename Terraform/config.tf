data "template_file" "setup_script" {
  template = file("${path.root}/scripts/deploy-dedcon.sh")

  vars = {
    server_name              = var.dedcon_server_name
    server_port              = var.dedcon_server_port
    server_key               = var.dedcon_server_key
    gamemode                 = var.dedcon_gamemode
    max_players              = var.dedcon_max_players
    territories_per_player   = var.dedcon_territories_per_player
    cities_per_territory     = var.dedcon_cities_per_territory
    population_per_territory = var.dedcon_population_per_territory
    city_population_mode     = var.dedcon_city_population_mode
    random_territories       = var.dedcon_random_territories
    score_mode               = var.dedcon_score_mode
  }
}
