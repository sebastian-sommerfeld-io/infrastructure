output "linode_account_email" {
  value       = data.linode_account.account.email
  description = "The email address of the Linode account in use"
}
