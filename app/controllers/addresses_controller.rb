class AddressesController < ApplicationController

  def sub_region
    render partial: 'sub_region_select', layout: false
  end
end