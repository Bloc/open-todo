class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :list_id
      t.string :description
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
