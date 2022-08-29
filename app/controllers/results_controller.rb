class ResultsController < ApplicationController

  def new
    @listeners = Listener.all
    @listener = params[:listener_id] ? Listener.find(params[:listener_id]) : @listeners.first
    @lottery = Lottery.find(params[:lottery_id])
    @rarities = Rarity.where(lottery_id: @lottery.id)
    @items = Item.where(rarity_id: @rarities.ids)
    @result = Result.new
    @results = Result.includes(:listener, :item).where(listener: @listener, lottery: @lottery).limit(1000)
  end

  def create
    lottery = Lottery.find(params[:result][:lottery_id])
    listener = Listener.find(params[:result][:listener_id])
    result_times = params[:result][:time].try(:to_i)

    result_list = []
    item_results(lottery, result_times).each do |item|
      result_list << Result.new(listener: listener, lottery: lottery, item: item)
    end
    Result.import result_list

    redirect_to new_result_path(lottery_id: lottery.id, listener_id: listener.id)
  end

  def destroy
    lottery = Lottery.find(params[:id])
    listener = Listener.find(params[:listener_id])
    Result.where(lottery: lottery, listener: listener).delete_all
    redirect_to new_result_path(lottery_id: lottery.id, listener_id: listener.id)
  end

  private

  def item_results(lottery, lottery_times)
    lottery_results = []
    lottery_inside = []
    lottery.rarities.each do |rarity|
      rarity_weight = rarity.weight
      rarity_weight.times {|i| lottery_inside << rarity }
    end

    rarity_results = []
    lottery_times.times {|i| rarity_results << lottery_inside.sample }
    rarity_results.each {|rarity| lottery_results << rarity.items.sample }
    lottery_results
  end
end
