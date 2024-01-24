#module "falco" {
#source = "./falco"
#}

#module "linkerd" {
#  source              = "./linkerd"
#}

module "argocd" {
source = "./argocd"
}

