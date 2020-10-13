class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit]
  before_action :move_to_index, only:[:edit]
  def index
    @items = Item.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit 
    @item = Item.find(params[:id])
  end

  def update   
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.valid?
      redirect_to item_path(params[:id])
    else
      render :edit
    end
  end
 

  private

  def item_params
    params.require(:item).permit(:image, :name, :text, :category_id, :status_id, :delivery_fee_id, :sender_area_id, :number_of_day_id, :money).merge(user_id: current_user.id)
  end

  def move_to_index
    item = Item.find(params[:id])
    if current_user.id != item.user.id || item.purchase != nil
      redirect_to root_path
    end
  end

end
