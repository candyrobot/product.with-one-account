class ImagesController < ApplicationController
  def show

  end

  def index
    render :json => Image.all
  end

  def create
    # 重複チェック
    # image = Image.where url: params[:url]
    # return if image.length != 0

    image = Image.new({url: params[:url] })
    image.save
  end

end
