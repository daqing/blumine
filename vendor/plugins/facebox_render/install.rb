require 'rubygems'

puts 'Copying files...'

public_path = File.join(Rails.root, 'public')
current_path = File.join(File.dirname(__FILE__), 'media') 

javascripts_path = File.join(public_path, 'javascripts')
stylesheets_path = File.join(public_path, 'stylesheets')
images_path      = File.join(public_path, 'images', 'facebox')

# copying JS
['facebox.js', 'facebox.pack.js'].each do |js_file|
  dest_file = File.join(javascripts_path, js_file)
  src_file  = File.join(current_path, 'javascripts', js_file)
  FileUtils.cp_r(src_file, dest_file)
end

# copying CSS
FileUtils.cp_r(File.join(current_path, 'stylesheets', 'facebox.css'), File.join(stylesheets_path, 'facebox.css'))

# copying images
Dir.mkdir(images_path) unless File.exists?(images_path) 

plugin_images_path = File.join(current_path, 'images')

Dir.foreach(plugin_images_path) do |image|
  src_image  = File.join(plugin_images_path, image)

  if File.file?(src_image)
    dest_image = File.join(images_path, image)
    FileUtils.cp_r(src_image, dest_image)
  end
end

puts 'Done - Installation complete!'
