module ApplicationHelper

  def owner
    @requirement.requestor_id == current_user.id
  end

  def add_class_active(current_selection, value)
    if current_selection == value
      'active'
    else
      ''
    end
  end

end
