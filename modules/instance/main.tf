####################
# Instance Template
####################

resource "google_compute_instance_template" "bookshelf-instance-template" {
#  name_prefix             = "${var.instance_template_name}-"
#  name_prefix             = var.instance_template_name
  name                    = var.instance_template_name
#  project                 = var.project
  machine_type            = var.machine_type
#  labels                  = var.labels
#  metadata                = var.metadata
/* metadata = {
   project_id         = var.project
   cloud_sql_password = var.sql_user_password
   connection_name    = var.sql_instance_connection_name
   cloud_sql_database = var.sql_database_name
   data_backend       = var.data_backend
} */
/* metadata = {
    startup-script = file(var.startup-script)
  } */
  tags                    = var.intance_template_tags
#  depends_on = [google_sql_database.gcp-lab-database, google_sql_database_instance.gcp-lab-sql-instance]
  depends_on = [var.google_sql_instance, var.google_sql_database]
#  can_ip_forward          = var.can_ip_forward

metadata_startup_script    = file("${path.root}/scripts/${var.startup-script}")

  region                  = var.region
  disk {
        auto_delete  = var.auto_delete
#      boot         = lookup(disk.value, "boot", null)
#      device_name  = lookup(disk.value, "device_name", null)
#      disk_name    = lookup(disk.value, "disk_name", null)
      disk_size_gb = var.disk_size_gb
      disk_type    = var.disk_type
#      interface    = lookup(disk.value, "interface", null)
#      mode         = lookup(disk.value, "mode", null)
#      source       = lookup(disk.value, "source", null)
      source_image = var.source_image
  }
  service_account {
    email  = "terraform-sa@gcp-training-iptcp.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

#Uncomment this block if you want to allocate external IP to your instance
/*     network_interface {
    network            = var.network_name
    subnetwork         = var.subnetwork_id
#    network_ip         = var.instance_network_ip
#    subnetwork_project = var.project
   } */
   
 dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      network = lookup(network_interface.value, "network", null)
      subnetwork = lookup(network_interface.value, "subnetwork", null)
      network_ip = lookup(network_interface.value, "network_ip", null)
    }
  } 
}
   /*   dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }  */
#  }
 
# Define an Ansible var_file containing Terraform variable values
/*  data "template_file" "tf_ansible_vars_file" {
  template = file("${path.root}/ansible/${var.tf_ansible_vars_file}")
  vars = {
    project_id         = var.project
    cloud_sql_password = var.sql_user_password
    connection_name    = var.sql_instance_connection_name
    cloud_sql_database = var.sql_database_name
    data_backend       = var.data_backend

  }
}  */

/*   
 resource "google_secret_manager_secret" "sql-user-password" {
  secret_id = var.sql_user_password_secret_id


  replication {
    user_managed {
      replicas {
        location = "europe-west1"
      }
      replicas {
        location = "europe-west1"
      }
    }
  }
} */



# Great solution but in order to get actual data we need to constantly push it to git and then pull it from instance
# Render the Ansible var_file containing Terrarorm variable values
       resource "local_file" "tf_ansible_vars_file" {
   #  content  = base64encode(yamlencode(
    content  = yamlencode(
    {
      project_id         = var.project
      cloud_sql_password = var.sql_user_password
      connection_name    = var.sql_instance_connection_name
      storage_bucket     = var.bookshelf-app-bucket
      data_backend       = var.data_backend
       
    #  cloud_sql_password = "${google_sql_user.default}"
    #  connection_name    = "{var.sql_instance_connection_name}"
     # cloud_sql_database = "{var.sql_database_name}"
    # data_backend       = var.data_backend
     # storage_bucket     = "{var.storage_bucket}"
      # gitlab_backup_bucket_name = aws_s3_bucket.gitlab_backup.
    }
  )
  #)
  /*  lifecycle {
    prevent_destroy = true
  } */

 /*   lifecycle {
    ignore_changes = all
  } */
/* 
  lifecycle {
    create_before_destroy = true
  } */

  filename = "${path.root}/ansible/${var.tf_ansible_vars_file}"
 # filename  = "${path.root}/ansible/tf_ansible_vars.tpl"
  #file_permission = var.file_permission 
  #directory_permission = var.dir_permission
 #filename = "${path.root}/ansible/tf_ansible_vars_file.yml.tpl"
 #filename = filebase64("${path.root}/ansible/tf_ansible_vars_file.yml.tpl")
 
}      
 

 # Define an Ansible var_file containing Terraform variable values
 /*    data "template_file" "tf_ansible_vars_file" {
   template = "${file("${path.root}/ansible/${var.tf_ansible_vars_file}")}"
  #template = base64encode(file("${path.root}/ansible/tf_ansible_vars.tpl"))
   vars = {
    project_id         = var.project
    cloud_sql_password = var.sql_user_password
    connection_name    = var.sql_instance_connection_name
  #  cloud_sql_database = var.sql_database_name
    storage_bucket     = var.storage_bucket
  }
}     */  
 
/*    dynamic "tf_vars" {
    for_each = var.tf_ansible_vars
    content {
      project_id         = lookup(tf_vars.value, "project_id", null)
      cloud_sql_password = lookup(tf_vars.value, "cloud_sql_password", null)
      connection_name    = lookup(tf_vars.value, "connection_name", null)
    #  cloud_sql_database = lookup(vars.value, "cloud_sql_database", null)
      storage_bucket     = lookup(tf_vars.value, "storage_bucket", null)
    }
   } */

/*  # Render the Ansible var_file containing Terrarorm variable values
    resource "local_file" "tf_ansible_vars_file" {
   #content  = data.template_file.tf_ansible_vars_file.rendered
  content = base64encode(yamlencode(data.template_file.tf_ansible_vars_file.rendered))
 #  "${base64encode(data.template_file.cloudconfig.rendered)}"
 # filename = "${path.root}/ansible/tf_ansible_vars_file.yml.tpl"
#   filename = "${path.root}/ansible/${var.tf_ansible_vars_file}"
 filename  = "${path.root}/ansible/${var.tf_ansible_vars_file}"
# filename = base64encode(file("${path.root}/ansible/tf_ansible_vars_file.yml.tpl"))
}  */ 
 

   

/* resource "google_compute_target_pool" "bookshelf-target-pool" {
  name = "bookshelf-app-tg-pool"
  region = var.region
  instances = [
    "europe-west1-b/bookshelf-app-instance"
  ]
  health_checks = [
#    google_compute_http_health_check.bookshelf-healthcheck.name,
     var.healthcheck_self_link,
  ]
} */

resource "google_compute_region_instance_group_manager" "bookshelf-app-group" {
  name = var.instance_group_name
  region = var.region

#  base_instance_name         = var.instance-template_name
   base_instance_name         = var.instance_template_name
 # region                     = var.region
  distribution_policy_zones  = ["europe-west1-b"]
 # target_size = 1
   // There is no way to unset target_size when autoscaling is true so for now, jsut use the min_replicas value.
  // Issue: https://github.com/terraform-providers/terraform-provider-google/issues/667
  #target_size = var.autoscaling_enabled ? var.min_replicas : var.size
  target_size = 1
  #target_pools = [google_compute_target_pool.bookshelf-target-pool.self_link]             
  #depends_on = [google_compute_instance_template.bookshelf-instance-template]
#  depends_on = [var.instance-template]
   depends_on = [google_compute_instance_template.bookshelf-instance-template]

  version {
    
  #  instance_template = google_compute_instance_template.bookshelf-instance-template.self_link
     name              = "primary"
    # instance_template = var.instance-template
     instance_template = google_compute_instance_template.bookshelf-instance-template.self_link
  }
  #In order to extract name variable for backend dynamic variable is good approach
    dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = lookup(named_port.value, "name", null)
      port = lookup(named_port.value, "port", null)
    }
  } 
}
  /*  auto_healing_policies {
    health_check      = var.healthcheck_self_link
    initial_delay_sec = 300
  } */ 
  

/* resource "google_compute_instance_group_named_port" "my_named_port" {
  group = google_compute_region_instance_group_manager.bookshelf-app-group.id
#  zone = var.zone

  name = "http"
  port = 8080
} */


 /*    named_port {
    name = "healthcheck-port"
    port = 8080
  }  */
/*   auto_healing_policies {
 #   health_check = "${google_compute_health_check.tcp_hc.self_link}"
   health_check   = var.healthcheck_self_link
  #  initial_delay_sec = "${var.initial_delay_sec}"
   initial_delay_sec = 60
  } */
 # target_pools = [google_compute_target_pool.bookshelf-target-pool.self_link]
 # target_size  = 1
 
/*   named_port {
    name = "healthcheck-port"
    port = 8080
  } */
#  auto_healing_policies {
#    health_check      = google_compute_http_health_check.bookshelf-healthcheck.self_link

  #  initial_delay_sec = 300
 #   initial_delay_sec = 120
# }

resource "google_compute_region_autoscaler" "instances-autoscaler" {
#  provider = google
#  count    = var.autoscaling_enabled ? 1 : 0
  name     = "${var.instance_template_name}-autoscaler"
#  project  = var.project
  region   = var.region
#  target   = google_compute_region_instance_group_manager.bookshelf-app-group.self_link
#  target   = var.instance_group_self_link
#   target = var.instance_group_id
#  target = var.instance_group_self_link
   target   = google_compute_region_instance_group_manager.bookshelf-app-group.id
#  depends_on = [google_compute_region_instance_group_manager.bookshelf-app-group]
  depends_on = [google_compute_region_instance_group_manager.bookshelf-app-group]
  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = var.cooldown_period
  cpu_utilization {
    #  target = 0.8 
    #Changed for testing autoscaling
       target = 0.2
    }
    }
   }
