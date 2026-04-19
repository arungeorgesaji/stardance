# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.find_or_create_by!(email: "kartikey@hackclub.com", slack_id: "U05F4B48GBF")
user.make_super_admin!
user.make_admin!

# Load comprehensive development seed in development environments
if Rails.env.development? && ENV.fetch("USE_BIG_SEED", false)
  puts "Loading comprehensive development seed..."
  load Rails.root.join('db', 'seeds', 'dev_full_seed.rb')
end
