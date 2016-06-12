class AddDateToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :date, :date
  end
end
