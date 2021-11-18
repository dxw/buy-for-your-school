class AddContentfulFieldsToPage < ActiveRecord::Migration[6.1]
  def up
    add_column :pages, :contentful_id, :string, null: false
    add_column :pages, :sidebar, :text

    # Allows us to use .upsert without having to worry about timestamps
    change_column :pages, :created_at, :datetime, null: false, default: -> { "CURRENT_TIMESTAMP" }
    change_column :pages, :updated_at, :datetime, null: false, default: -> { "CURRENT_TIMESTAMP" }

    add_index :pages, :contentful_id, unique: true
  end

  def down
    remove_index :pages, :contentful_id, unique: true

    remove_column :pages, :contentful_id
    remove_column :pages, :sidebar

    change_column :pages, :created_at, :datetime, null: false
    change_column :pages, :updated_at, :datetime, null: false
  end
end
