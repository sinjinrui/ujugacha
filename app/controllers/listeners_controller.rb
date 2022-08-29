class ListenersController < ApplicationController
  def index
    @listeners = Listener.all
    @listener = Listener.new
  end

  def create
    @listener = Listener.new(name: params[:listener][:name])
    @listener.save
    redirect_to listeners_path
  end

  def destroy
    @listener = Listener.find(params[:id])
    @listener.destroy
    redirect_to listeners_path
  end
end
