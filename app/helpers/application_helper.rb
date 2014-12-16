module ApplicationHelper

  def owner
    @requirement.requestor_id == current_user.id
  end

  def add_class_if_active(filter)
    if filter == params[:filter]
      'active'
    else
      ''
    end
  end

end
