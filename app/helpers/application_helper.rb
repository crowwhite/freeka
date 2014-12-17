module ApplicationHelper

  def owner(requirement)
    if current_user
      requirement.requestor_id == current_user.id
    end
  end

  def add_class_active(current_selection, value)
    if current_selection == value
      'active'
    else
      ''
    end
  end

end
