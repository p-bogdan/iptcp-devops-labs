resource "google_storage_bucket" "bookshelf-data" {
  name = "bookshelf-app-data-${var.random_id_hex}"
#name = "bookshelf_app_data2"
  location      = "EU"
}


resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.bookshelf-data.id
  role   = "READER"
  entity = "allUsers"
  depends_on = [google_storage_bucket.bookshelf-data]
}
