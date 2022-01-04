module "peering" {
  source = "terraform-google-modules/network/google//modules/network-peering"

  prefix        = "vpc-peering"
  local_network = module.vpc.network_self_link
  peer_network  = module.vpc-peer.network_self_link
}