class PurchasesController < ApplicationController
  before_action :move_to_index
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]

  def index
    if current_user.id == @item.user_id
      redirect_to root_path
    else
      @purchase_address = PurchaseAddress.new
    end
  end

  def create
    @purchase_address = PurchaseAddress.new(purchase_params)
    if @purchase_address.valid?
      pay_item
      @purchase_address.save
      redirect_to root_path
    else
      render 'index'
    end
  end

  private

  def purchase_params
    params.require(:purchase_address).permit(:postal_code, :prefecture_id, :municipality, :house_number, :building_name, :tel).merge(token: params[:token], user_id: current_user.id, item_id: params[:item_id])
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.money,
      card: purchase_params[:token],
      currency: 'jpy'
    )
  end

  def move_to_index
    item_purchase = Purchase.find_by(item_id: params[:item_id])
    redirect_to root_path unless item_purchase.nil?
  end

  def set_item
    @item = Item.find(params[:item_id])
  end
end
