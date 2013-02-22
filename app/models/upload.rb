class Upload < ActiveRecord::Base
  attr_accessible :upload,:post_id,:random_mark
  has_attached_file :upload,
    :url => "/images/photos/:id/:basename_:style.:extension",
    :path => ":rails_root/public/images/photos/:id/:basename_:style.:extension",
    :styles => {
    :content=>"600>",
    :medium => "240x180^",
    :thumb => "80x80^" }
  belongs_to :post

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "medium_url" => upload.url(:medium),
      "thumbnail_url" => upload.url(:thumb),
      "delete_url" => upload_path(self),
      "delete_type" => "DELETE" 
    }
  end

end
