# Namespace for IOT backend services.
resource "kubernetes_namespace_v1" "iot_backend" {
  metadata {
    name = "iot-backend"
  }
}

module "mosquitto" {
  source    = "./module/iot-backend/mosquitto"
  namespace = kubernetes_namespace_v1.iot_backend.metadata.0.name

  mosquitto_version = "2.0.15"
  mosquitto_conf    = "./data/mosquitto/mosquitto.conf"
}

module "zigbee2mqtt" {
  source    = "./module/iot-backend/zigbee2mqtt"
  namespace = kubernetes_namespace_v1.iot_backend.metadata.0.name

  chart_version = "9.4.2"

  ui_host = "z2m.${var.domain}"

  # Read as template
  values = templatefile("./data/zigbee2mqtt/values.yaml", {
    "usb_path" = "/dev/ttyUSB0"
  })

}