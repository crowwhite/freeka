# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(drop_down_icon.js push_notifier.js scrollable_element.js status_button.js request_tile.js loading_button.js faliure_link.js link.js bootstrap.js sub_region_select.js sub_category_select.js multifile-master/jQuery.MultiFile.min.js )
