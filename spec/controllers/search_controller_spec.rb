require 'rails_helper'

RSpec.describe SearchController, :type => :controller do

  describe "GET find_need" do
    it "returns http success" do
      get :find_need
      expect(response).to have_http_status(:success)
    end
  end

  RSpec.configure do |c|
    c.filter_run_excluding :broken => true
  end

  describe "GET find_need with query", :broken => true do
    it "finds the need by goal" do
      need = create(:need, goal: 'The quick brown fox')
      get :find_need, :q => 'brown'
      expect(response).to have_http_status(:success)
      expect(assigns(:needs)).to contain_exactly(need)
    end
  end
end
