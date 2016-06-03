class AddLevelToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :level, :integer
  end
end
