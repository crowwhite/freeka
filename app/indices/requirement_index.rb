ThinkingSphinx::Index.define :requirement, :with => :active_record, :delta => true do
  indexes title, :sortable => true
  indexes details
  indexes person(:name)
  indexes person(:email)
  indexes address(:city)

  has requestor_id, created_at, updated_at
end