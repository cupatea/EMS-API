class Event < ApplicationRecord
  mount_base64_uploader :attachment, AttachmentUploader, file_name: -> { "event_file-#{DateTime.now.to_i}" }
  has_and_belongs_to_many :users
  has_many :comments
end
