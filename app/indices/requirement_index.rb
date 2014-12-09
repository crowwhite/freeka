ThinkingSphinx::Index.define :requirement, :with => :active_record, :delta => true do
  indexes title, :sortable => true
  indexes details
  indexes person(:name)
  indexes person(:email)
  indexes address(:city)
  indexes address(:country_code)
  indexes address(:state_code)
  indexes interested_donors(:name)

  has requestor_id, created_at, updated_at, expiration_date, status, enabled
end