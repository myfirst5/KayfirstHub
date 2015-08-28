class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :amazon_order_id
      t.string :purchase_date
      t.string :amount
      t.string :buyer_name

      t.timestamps null: false
    end
  end
end
