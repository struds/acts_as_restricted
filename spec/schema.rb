ActiveRecord::Schema.define(:version => 1) do
  create_table :items, :force => true do |t|
    t.integer :id
    t.string :name
    t.string :group_id
  end

  create_table :groups, :force => true do |t|
    t.integer :id
    t.string :name
    t.integer :user_id
  end
end
