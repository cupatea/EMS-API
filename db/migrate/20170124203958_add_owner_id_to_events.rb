class AddOwnerIdToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :owner_id, :integer
  end
  create_table :events_users, id: false do |t|
    t.belongs_to :event, index: true
    t.belongs_to :user, index: true
  end
end
