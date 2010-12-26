class AddMrpToVariants < ActiveRecord::Migration
  def self.up
	   add_column :variants, :mrp, :decimal,
	  :precision => 8, :scale => 2, :default => 0
  end

  def self.down
	remove_column :variants, :mrp
  end
end
