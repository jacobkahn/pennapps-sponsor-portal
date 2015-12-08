RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    toggle
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do 
    object_label_method do
      :custom_label_method
    end
    list do
      field :name
      field :logo_valid, :toggle
      field :payment_received, :toggle
      field :created_at do
        date_format :short
      end
      field :updated_at do
        strftime_format "%Y-%m-%d"
      end
      # configure :activated do
      #   hide
      # end
      # configure :activated_at do
      #   hide
      # end
      # configure :remember_digest do
      #   hide
      # end
      # configure :password_digest do
      #   hide
      # end
      # configure :activation_digest do
      #   hide
      # end
    end
    exclude_fields :activated, :activated_at, :remember_digest, :password_digest
    exclude_fields :activation_digest, :reset_digest, :reset_sent_at
  end

  def custom_label_method
    "#{self.email}"
  end

  config.authorize_with do
    authenticate_or_request_with_http_basic('Login required') do |username, password|
      username == Rails.application.secrets.user &&
      password == Rails.application.secrets.password
    end
  end
end
