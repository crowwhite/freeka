module ApplicationHelper

  def owner(requirement)
    if current_user
      requirement.requestor_id == current_user.id
    end
  end

  def add_class_active_if_filter(filter, value)
    if filter == 'page'
      if controller_name == value
        'active'
      else
        ''
      end
    elsif filter == 'status'
      if value == params[:filter]
        'active'
      else
        ''
      end
    end
  end

end
