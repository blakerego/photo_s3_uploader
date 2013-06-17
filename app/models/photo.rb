class Photo < ActiveRecord::Base
  attr_accessible :name, :image, :image_processed
  mount_uploader :image, ImageUploader

  after_save :enqueue_image

  def image_name
    File.basename(image.path || image.filename) if image
  end

  def enqueue_image
    # ImageWorker.perform_async(id, key) if key.present? && !image_processed
    photo = Photo.find(id)
    # photo.recreate_versions  
    photo.key = key
    photo.remote_image_url = photo.image.direct_fog_url(with_path: true)
    photo.save!
    photo.update_attributes(:image_processed => true)
    # photo.update_column(:image_processed, true)
  end

  class ImageWorker
    include Sidekiq::Worker
    
    def perform(id, key)
      photo = Photo.find(id)
      photo.recreate_versions  
      # photo.key = key
      # photo.remote_image_url = photo.image.direct_fog_url(with_path: true)
      # photo.save!
      photo.update_column(:image_processed, true)
    end
  end

end
