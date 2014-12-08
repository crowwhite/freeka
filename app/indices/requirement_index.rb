ThinkingSphinx::Index.define :requirement, :with => :active_record, :delta => true do
  indexes title, :sortable => true
  indexes details
  indexes status
  indexes person(:name)
  indexes person(:email)
  indexes address(:city)
  indexes address(:country_code)
  indexes address(:state_code)

  has requestor_id, created_at, updated_at, expiration_date
end