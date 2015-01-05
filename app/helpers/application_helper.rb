module ApplicationHelper

  def owner(requirement)
    requirement.requestor_id == current_user.id if current_user
  end

  def add_class_active(current_selection, value)
    current_selection == value ? 'active' : ''
  end

  def display_page
    @display_page || controller_name
  end

  def add_class_enabled_or_disabled(object_value, comparison_value)
    object_value == comparison_value ? 'active-object' : 'inactive-object'
  end

  def default_requirement_image_url
    '/give-charity-donations.jpg'
  end

end
