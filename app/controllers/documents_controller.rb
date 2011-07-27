class DocumentsController < ApplicationController
  before_filter :must_login_first
  before_filter :find_project
  before_filter :find_document, :except => [:new, :create, :index]
  authorize_resource

  def index
    @documents = @project.documents
    respond_to do |f|
      f.html
      f.json { render :json => @project.documents }
    end
  end

  def new
    @project = Project.find(params[:project_id])
    @document = @project.documents.new

    breadcrumbs.add @project.name, project_path(@project)
    breadcrumbs.add t(:new_document)
  end

  def create
    @project = Project.find(params[:project_id])
    @document = @project.documents.build(params[:document])
    @document.user = current_user
    if @document.save
      Activity.create!(
        :user_id => current_user.id,
        :project_id => params[:project_id],
        :event_name => 'create_document',
        :target_id => @document.id,
        :data => {:project_name => @project.name, :document_title => @document.title}
      )
      redirect_to [@project, @document]
    else
      render :new
    end
  end

  def show
    breadcrumbs.add @project.name, project_path(@project)
    breadcrumbs.add "#doc-#{@document.id}", project_document_path(@project, @document)
  end

  def edit
    breadcrumbs.add @project.name, project_path(@project)
    breadcrumbs.add "#doc-#{@document.id}", project_document_path(@project, @document)
    breadcrumbs.add t(:edit)
  end

  def update
    if @document.update_attributes(params[:document])
      # create activity
      begin
        Activity.create!(:event_name => 'edit_document',
                         :user_id => current_user.id,
                         :project_id => @project.id,
                         :target_id => @document.id,
                         :data => {:title => @document.title, :url => project_document_path(@project, @document)}
                        )
      rescue
      end

      redirect_to [@project, @document]
    else
      render :edit
    end
  end

  def destroy
    if @document.destroy
      redirect_to @project
    else
      flash[:error] = t(:destroy_failed)
      redirect_to root_path
    end
  end

  private
    def find_document
      @document = @project.documents.find(params[:id])
    end
end
