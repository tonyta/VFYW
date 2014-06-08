# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}"
  end

  def fix_rotation
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  process :fix_rotation # this should go before all other "process" steps
  process resize_to_fit: [400, 400]

  version :thumb do
    process :resize_to_fill => [120,120]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
     "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

end
