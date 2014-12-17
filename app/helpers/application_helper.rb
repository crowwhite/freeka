module ApplicationHelper

  def owner(requirement)
    if current_user
      requirement.requestor_id == current_user.id
    end
  end

end
