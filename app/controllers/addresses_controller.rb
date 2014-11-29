# TODO: No need of authetication here??
# It has no direct access anywhere in views. Only called indirectly
class AddressesController < ApplicationController

  def sub_region
    render partial: 'sub_region_select', layout: false
  end
end