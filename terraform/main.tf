resource "kubernetes_namespace" "devops" {
  metadata {
    name = "devops"
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "devops-fullstack-app"
    namespace = "devops"
  }

  spec {
    replicas = 1

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = "1"
        max_unavailable = "0"
      }
    }

    selector {
      match_labels = {
        app = "devops-fullstack-app"
      }

    }

    template {
      metadata {
        labels = {
          app = "devops-fullstack-app"
        }        
      }

      spec {
        container {
          name              = "devops-fullstack-app"
          image             = "devops-fullstack-app:${var.image_tag}"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 3000
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds = 5
          }

          resources {
            requests = {
              cpu = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu = "250m"
              memory = "256Mi"
            }
          }
        }
        
      }


    }
    
  }
  
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_service" "app" {
  metadata {
    name = "devops-fullstack-app"
    namespace = "devops"
  }

  spec {
    selector = {
      app = "devops-fullstack-app"
    }

    port {
      port = 3000
      target_port = 3000
    }
    type = "NodePort"
  } 
}