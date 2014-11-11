require 'rails_helper'

describe CategoriesController do
  
  describe '#index' do
    it 'renders index template' do
      get 'index'
      expect(response).to render_template(:index)
    end
  end

end
