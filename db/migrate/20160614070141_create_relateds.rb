class CreateRelateds < ActiveRecord::Migration[5.0]
  def change
    create_table :relateds do |t|
      t.string :wistia

      t.timestamps
    end
  end
end
