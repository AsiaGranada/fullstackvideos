class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.string :url
      t.string :text
      t.string :description

      t.timestamps
    end
  end
end
