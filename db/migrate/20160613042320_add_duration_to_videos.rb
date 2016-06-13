class AddDurationToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :duration, :string
  end
end
