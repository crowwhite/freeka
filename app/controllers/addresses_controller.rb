# TODO: No need of authetication here??
class AddressesController < ApplicationController

  def sub_region
    render partial: 'sub_region_select', layout: false
  end
end