# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Add the GOVUK Frontend images path
Rails.application.config.assets.paths << Rails.root.join("node_modules/govuk-frontend/govuk/assets/images")

# Add the GOVUK Frontend fonts path
Rails.application.config.assets.paths << Rails.root.join("node_modules/govuk-frontend/govuk/assets/fonts")

# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("node_modules")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# Add GOVUK assets by name, these are assets not loaded via sass
Rails.application.config.assets.precompile += [
  "favicon.ico",
  "govuk-apple-touch-icon-152x152.png",
  "govuk-apple-touch-icon-167x167.png",
  "govuk-apple-touch-icon-180x180.png",
  "govuk-apple-touch-icon.png",
  "govuk-crest-2x.png",
  "govuk-crest.png",
  "govuk-logotype-crown.png",
  "govuk-mask-icon.svg",
  "govuk-opengraph-image.png",
]
