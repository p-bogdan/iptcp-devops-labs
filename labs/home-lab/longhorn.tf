#Applying node labels to worker nodes
resource "kubectl_manifest" "longhorn" {
  for_each = toset([
    "kubernetes-worker",
    "kubernetes-worker2",
    "k8s-worker4"
  ])

  yaml_body = <<YAML
apiVersion: v1
kind: Node
metadata:
  name: ${each.value}
  labels:
    node.longhorn.io/create-default-disk: "true"
YAML
}
