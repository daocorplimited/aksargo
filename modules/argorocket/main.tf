resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  depends_on = [kubernetes_namespace.argocd]
}

resource "kubectl_manifest" "argoapp1" {
  depends_on = [helm_release.argocd]
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: supabase
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://supabase-community.github.io/supabase-kubernetes
    targetRevision: HEAD
    chart: supabase
  destination:
    server: https://kubernetes.default.svc
    namespace: supabase
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      selfHeal: true
      prune: true 
      allowEmpty: false 
YAML
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "supabase" {
  metadata {
    name = "supabase"
  }
}