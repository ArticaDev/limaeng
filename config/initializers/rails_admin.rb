RailsAdmin.config do |config|
  config.asset_source = :sprockets
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.model 'State' do 
    label 'Estados'
    list do
      field :name do
        read_only true
        label 'Nome'
      end

      field :abbreviation do 
        read_only true
        label 'Abreviação'
      end
      field :low_price_per_meter do 
        label 'Valor m² - padrão baixo'
      end
      field :medium_price_per_meter do
        label 'Valor m² - padrão médio'
      end
      field :high_price_per_meter do 
        label 'Valor m² - padrão alto'
      end
    end
    export do
      field :name do
        label 'Nome'
      end

      field :abbreviation do 
        label 'Abreviação'
      end
      field :low_price_per_meter do 
        label 'Valor m² - padrão baixo'
      end
      field :medium_price_per_meter do
        label 'Valor m² - padrão médio'
      end
      field :high_price_per_meter do 
        label 'Valor m² - padrão alto'
      end
    end
    edit do
      field :name do
        read_only true
        label 'Nome'
      end

      field :abbreviation do 
        read_only true
        label 'Abreviação'
      end
      field :low_price_per_meter do 
        label 'Valor m² - padrão baixo'
      end
      field :medium_price_per_meter do
        label 'Valor m² - padrão médio'
      end
      field :high_price_per_meter do 
        label 'Valor m² - padrão alto'
      end
    end
  end

  config.model 'GroupType' do
    label 'Checklist de validação de obra - Areas'
    list do 
      field :name do
        label 'Nome'
      end
    end
    edit do 
      field :name do
        label 'Nome'
      end
    end
  end

  config.model 'CategoryType' do
    label 'Checklist de validação de obra - Categorias'
    list do 
      field :name do
        label 'Nome'
      end
      field :group_type do 
        label 'Area'
      end
    end
    edit do 
      field :name do
        label 'Nome'
      end
      field :group_type do 
        label 'Area'
      end
    end
  end

  config.model 'ItemType' do
    label 'Checklist de validação de obra - Itens'
    list do 
      field :name do
        label 'Nome'
      end
      field :category_type do
        label 'Categoria'
      end
    end
    edit do
      field :name do
        label 'Nome'
      end
      field :category_type do
        label 'Categoria'
      end
    end
  end

  config.actions do
    dashboard do 
      only ['State', 'CategoryType', 'ItemType', 'GroupType']
    end
    index do
      only ['State', 'CategoryType', 'ItemType', 'GroupType']
    end 
    new do 
      only ['CategoryType', 'ItemType', 'GroupType']
    end
    export  do
     only ['State']
    end 
    # bulk_delete
    # show
    edit do
      only ['State', 'CategoryType', 'ItemType', 'GroupType']
    end 
    delete do 
      ['CategoryType', 'ItemType', 'GroupType']
    end
    # show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
