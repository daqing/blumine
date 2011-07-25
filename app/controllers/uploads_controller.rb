class UploadsController < ApplicationController
  before_filter :find_project

  def index
    @uploads = @project.uploads
  end

  def new
    @upload = @project.uploads.new
  end

  def create
    @upload = @project.uploads.build(params[:upload])
    @upload.user = current_user
    if @upload.save
      # create activity
      begin
        url = @upload.asset.url
        name = File.basename(url)
        data = {:url => url, :name => name, :mime => @upload.content_type}
        data[:thumb] = @upload.asset.thumb.url if @upload.image?
        Activity.create!(:event_name => 'create_upload',
                         :target_id => @upload.id,
                         :user_id => current_user.id,
                         :project_id => @project.id,
                         :data => data
                        )
      rescue
      end
      redirect_to project_uploads_path(@project)
    else
      render :new
    end
  end

  private
    def find_project
      @project = Project.find(params[:project_id])
    end
end
