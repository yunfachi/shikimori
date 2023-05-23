class ConvertForeignKeysToBigintV2 < ActiveRecord::Migration[6.1]
  TABLES = {
    users: %i[id],
    user_preferences: %i[id user_id]
  }

  def up
    TABLES.each do |table, fields|
      Array(fields).each do |field|
        change_column table, field, :bigint
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end