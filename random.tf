# Randoms
resource "random_password" "db_password" {
    length = 16
    special = false
}

resource "random_password" "db_secret_key" {
    length = 51
    special = false
}