require 'digest'
module UploaderHelper
  # Override the filename of the uploaded files:
  def filename
    if original_filename
      ext = File.extname(original_filename)
      new_name = Digest::SHA1.hexdigest(File.basename(original_filename, ext))[5..10]
      "#{new_name}#{ext}"
    end
  end
end
