resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  depends_on = [kubernetes_namespace.argocd]
}

resource "helm_release" "supabase" {
  name       = "supabase"
  namespace  = "supabase"
  repository = "https://supabase-community.github.io/supabase-kubernetes"
  chart      = "supabase"
  depends_on = [kubernetes_namespace.supabase]
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