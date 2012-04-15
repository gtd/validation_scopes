ActiveRecord::Schema.define do
  create_table "users" do |t|
    t.column "name",       :string
    t.column "email",      :string
    t.column "age",        :integer
    t.column "bio",        :text
    t.column "sponsor_id", :integer
  end

  create_table "books" do |t|
    t.column "title",      :string
    t.column "author",     :string
    t.column "isbn",       :integer
    t.column "user_id",    :integer
  end
end
