class PhotosController < ApplicationController
  def index
    @photos = Photo.all
  end

  def create
    @photo = Photo.new(params[:photo])
    if @photo.save
      redirect_to photo_path(@photo)
    else
    end
  end

  def new 
    @photo = Photo.new
  end

  def show
    @photo = Photo.find(params[:id])
  end

end