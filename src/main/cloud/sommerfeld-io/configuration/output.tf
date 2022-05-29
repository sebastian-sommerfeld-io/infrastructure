output "do_account_email" {
  value       = data.digitalocean_account.do_account.email
  description = "The email address of the DigitalOcean account in use"
}

output "do_docs_page_live_url" {
  value       = data.digitalocean_app.docs-page-data.live_url
  description = "The <subdomain>.cloud.sommerfeld.io domain"
}

output "do_docs_page_default_url" {
  value       = data.digitalocean_app.docs-page-data.default_ingress
  description = "The <random-subdomain>.ondigitalocean.app domain"
}

# ----------------------------------------------------------------------------------------------------------------------

output "linode_account_email" {
  value       = data.linode_account.linode_account.email
  description = "The email address of the Linode account in use"
}
