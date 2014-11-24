ThinkingSphinx::Index.define :requirement, :with => :active_record do
  indexes title, :sortable => true
  indexes details
  indexes person(:name), :as => :requestor, :sortable => true

  has requestor_id, created_at, updated_at
end