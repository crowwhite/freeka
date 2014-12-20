module ApplicationHelper

  def owner(requirement)
    requirement.requestor_id == current_user.id if current_user
  end

  def add_class_active(current_selection, value)
    current_selection == value ? 'active' : ''
  end

end
