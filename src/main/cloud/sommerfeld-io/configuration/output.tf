output "linode_account_email" {
  value       = data.linode_account.linode_account.email
  description = "The email address of the Linode account in use"
}

output "do_account_email" {
  value       = data.digitalocean_account.do_account.email
  description = "The email address of the DigitalOcean account in use"
}
