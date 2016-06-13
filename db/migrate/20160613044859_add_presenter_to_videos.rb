class AddPresenterToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :presenter, :string
  end
end
