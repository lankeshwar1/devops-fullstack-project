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
    replicas = 2

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