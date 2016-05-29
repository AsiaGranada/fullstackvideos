class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :role
      t.string :mailing_list_id
      t.string :list_group
      t.integer :price

      t.timestamps
    end
  end
end
