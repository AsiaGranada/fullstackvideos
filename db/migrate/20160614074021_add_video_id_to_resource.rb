class AddVideoIdToResource < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :video_id, :integer
  end
end
