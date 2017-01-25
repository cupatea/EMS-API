class AddAttachmentToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :attachment, :string
  end
end
