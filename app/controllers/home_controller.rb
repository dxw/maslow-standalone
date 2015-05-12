class HomeController < SimpleController

  def index
    if not User.all.blank?
      redirect_to needs_path
    end
  end
end
