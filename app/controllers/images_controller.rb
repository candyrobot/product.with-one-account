class ImagesController < ApplicationController
  def show

  end

  def index
    render :json => Image.all
  end

  def create
    image = Image.new({url: params[:url] })
    image.save
  end

end
