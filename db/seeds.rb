# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default User
user = User.find_or_initialize_by(email_address: "admin@example.com", display_name: "Admin", username: "admin")
user.update!(password: "password", password_confirmation: "password")

# Create Modules
## Active Module
OpenVoxModule.find_or_initialize_by(
  name: "examplemodule",
  slug: "example_module",
  homepage_url: "https://example.com/",
  issues_url: "https://exmaple.com/",
  user: user
).save

## Deleted Module
OpenVoxModule.find_or_initialize_by(
  name: "deletedmodule",
  slug: "deleted_module",
  homepage_url: "https://example.com/",
  issues_url: "https://exmaple.com/",
  user: user
).save

## Deprecated Module
OpenVoxModule.find_or_initialize_by(
  name: "deprecatedmodule",
  slug: "deprecated_module",
  homepage_url: "https://example.com/",
  issues_url: "https://exmaple.com/",
  user: user
).save
