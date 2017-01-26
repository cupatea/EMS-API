class Event < ApplicationRecord
  include PublicActivity::Model
  tracked
  mount_base64_uploader :attachment, AttachmentUploader, file_name: -> { "event_file-#{DateTime.now.to_i}" }
  has_and_belongs_to_many :users
  has_many :comments

  scope :with_interval, -> (interval) { where( time: Date.today...(Date.today + interval.days)) }
end
