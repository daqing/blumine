class ImagesController < ApplicationController
  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to root_path }
        format.js
      else
        format.html { redirect_to root_path }
        format.js { render :text => "ERROR", :status => 500 }
      end
    end
  end

  def update
  end

end
