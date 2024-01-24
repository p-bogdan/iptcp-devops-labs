# resource "kubernetes_namespace" "security" {
#   metadata {
#     annotations = {
#       name = "falco"
#     }

#     labels = {
#       name = "falco"
#     }

#     name = "falco"
#   }
# }