class CreateReadCounts < ActiveRecord::Migration[7.1]
  def change
    create_table :read_counts do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
