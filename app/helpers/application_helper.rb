module ApplicationHelper

  def owner
    @requirement.requestor_id == current_user.id
  end

end
