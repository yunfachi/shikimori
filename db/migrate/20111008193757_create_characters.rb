class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.string :name
      t.string :japanese
      t.string :fullname
      t.text :description
      t.text :description_mal
      t.text :spoiler
      t.text :spoiler_mal

      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end
