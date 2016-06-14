class AddVideoIdToRelated < ActiveRecord::Migration[5.0]
  def change
    add_column :relateds, :video_id, :integer
  end
end
