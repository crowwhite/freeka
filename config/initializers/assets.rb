# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( remove_file.js bootstrap.js sub_categories.js new_sub_category.js sub_region_select.js sub_category_select.js nested_form.js progressbar.gif loading.gif multifile-master/jQuery.MultiFile.min.js )
