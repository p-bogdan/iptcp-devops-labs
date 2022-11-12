${yamlencode(
{
    version = "3.9"
    services = {
      wireguard = {
        image = "linuxserver/wireguard"
        container_name = "wireguard"
      cap_add = ["NET_ADMIN", "SYS_MODULE"]
       environment = ["PUID=1000", "PGID=1000", "TZ=Europe/Kyiv", "SERVERURL=${public_ip}", "SERVERPORT=51820", "PEERS=1", "PEERDNS=auto", "INTERNAL_SUBNET=10.13.13.0", "ALLOWEDIPS=0.0.0.0/0", "LOG_CONFS=true" ]
       volumes = ["/opt/wireguard-server/config:/config", "/lib/modules:/lib/modules"]
       ports = ["51820:51820/udp"]
       sysctls = ["net.ipv4.conf.all.src_valid_mark=1"]
       restart = "unless-stopped"
      }
    }  
}
)}