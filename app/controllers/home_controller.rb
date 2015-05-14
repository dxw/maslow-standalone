class HomeController < ActionController::Base
  layout 'skeleton'

  def index
    if ! User.all.blank?
      redirect_to needs_path
    end
  end
end
