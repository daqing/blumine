class ImagesController < ApplicationController
  def new
    @image = Image.new
    
    render 'new', :layout => 'clean'
  end

  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { render 'create', :layout => 'clean' }
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
