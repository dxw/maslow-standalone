class AddImpactToNeeds < ActiveRecord::Migration
  def up
    create_table :impacts do |t|
      t.text :description
      t.timestamps null: false
    end

    add_reference :needs, :impact, index: true
  end

  def down
    remove_reference :needs, :impact
    drop_table :impacts
  end
end
