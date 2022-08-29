class LotteriesController < ApplicationController

  before_action :find_lottery, only: [:edit, :destroy, :update]

  def new
    @lottery = Lottery.new
    @rarity = Rarity.new
  end

  def create
    @lottery = Lottery.new(lottery_params)
    rarities = []
    ActiveRecord::Base.transaction do
      @lottery.save
      lottery_id = @lottery.id
      params[:lottery][:rarities].each do |rarity_param|
        rarity = Rarity.new(rarity_params(rarity_param, lottery_id))
        rarities << rarity if rarity.name.present? && rarity.weight.present?
      end
      rarity_weight_check(rarities)
      Rarity.import rarities
    end
    redirect_to lotteries_path
  rescue
    redirect_to new_lottery_path
  end

  def index
    @lotteries = Lottery.all
  end
  
  def edit
    @rarities = Rarity.where(lottery: @lottery)
    @item = Item.new
    @items = Item.where(rarity_id: @rarities.ids)
    @form_length = 0
    @rarities.each {|r| @form_length += r.items.length }
    @form_length = @form_length > 3 ? @form_length : 3
    @rarity_names = @rarities.pluck(:name)
  end

  def update
    binding.pry
    items = []
    ActiveRecord::Base.transaction do
      # ここにlotteryのupdateも追加する
      if params[:lottery][:items].present?
        params[:lottery][:items].each do |item_param|
          item = Item.new(name: item_param[:name], rarity_id: item_param[:rarity_id])
          items << item if item.name.present?
        end
      end
      if params[:lottery][:current_items].present?
        params[:lottery][:current_items].each do |current_item_param|
          item = Item.new(id: current_item_param[0], name: current_item_param[1][:name], rarity_id: current_item_param[1][:rarity_id])
          items << item if item.name.present?
        end
      end
      Item.import items, on_duplicate_key_update: [:name, :rarity_id]
    end
    redirect_to lotteries_path
  rescue
    redirect_to edit_lottery_path(@lottery.id)
  end

  def destroy
    ActiveRecord::Base.transaction do
      Result.where(lottery: @lottery).delete_all
      Item.where(rarity: @lottery.rarities).delete_all
      Rarity.where(lottery: @lottery).delete_all
      @lottery.destroy
      redirect_to lotteries_path
    end
  rescue
    render "index"
  end

  private

  def lottery_params
    params.require(:lottery).permit(:name)
  end

  def rarity_params(param, lottery_id)
    param.permit(:name, :weight).merge(lottery_id: lottery_id)
  end

  def find_lottery
    @lottery = Lottery.find(params[:id])
  end

  def rarity_weight_check(rarities)
    total_weight = 0
    rarities.each {|rarity| total_weight += rarity.weight }
    raise StandardError if total_weight != 100
  end

end
