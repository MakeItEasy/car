ActiveAdmin.register Catagory do
  config.sort_order = 'order_asc'
  permit_params :name, :order, :memo
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  # scope :all, default: true
  index do
    selectable_column
    column :order
    column :name
    column :memo
    actions
  end

  filter :name
  
end
