
resource "google_secret_manager_secret" "secret-basic" {
  depends_on = [var.local_file]
  secret_id  = "tf-ansible-vars"

  labels = {
    label = "tf-ansible-vars"
  }

  replication {
    automatic = true
    #    automatic = false

  }
}


/*   data "google_secret_manager_secret_version" "basic" {
 # depends_on = [google_secret_manager_secret.secret-basic, var.local_file]
 # secret = base64decode(file(var.tf_ansible_vars_file))
 secret = google_secret_manager_secret.secret-basic.id
 version = ""
} 
  */


resource "google_secret_manager_secret_version" "secret-version-basic" {
  # depends_on = [google_secret_manager_secret.secret-basic, var.local_file]
  depends_on = [var.local_file]
  # secret = google_secret_manager_secret.secret-basic.id
  secret = google_secret_manager_secret.secret-basic.id
  #  enabled = var.enabled_secret_versioning
  #  versioning = var.secret_version

  #secret_data = var.secret_data
  #  secret_data = var.secret_data == "" ? var.random_id : var.secret_data
  #secret_data = file("${path.root}/ansible/tf_ansible_vars_file.yml.tpl")
  secret_data = file(var.tf_ansible_vars_file)
  #Decrypt data with secrets
  # secret_data = base64decode(file(var.tf_ansible_vars_file))
  # Copies the myapp.conf file to /etc/myapp.conf

  #secret_data = base64encode(file("${path.root}/ansible/tf_ansible_vars_file.yml.tpl"))
}
 