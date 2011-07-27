class DocumentSectionsController < ApplicationController
  before_filter :find_project, :only => :create

  def create
    @document = @project.documents.find(params[:document_id])
    @document_section = @document.document_sections.build(params[:document_section])

    respond_to do |f|
      if @document_section.save
        begin
          # create activity
          Activity.create!(:user_id => current_user.id,
                           :event_name => 'create_document_section',
                           :target_id => @document_section.id,
                           :project_id => @project.id,
                           :data => {:title => @document_section.title, :doc_title => @document.title,  :doc_url => project_document_path(@project, @document)}
                          )
        rescue
        end
        f.html { redirect_to [@project, @document] }
        f.js
      else
        f.html { redirect_to [@project, @document] }
        f.js { render :text => :error, :status => 500 }
      end
    end
  end

  def edit
    @document_section = DocumentSection.find(params[:id])
    @document = @document_section.document
    @project = @document.project

    respond_to do |format|
      format.js
    end
  end

  def update
    @document_section = DocumentSection.find(params[:id])
    @document = @document_section.document
    @project = @document.project

    respond_to do |format|
      if @document_section.update_attributes(params[:document_section])
        begin
          # create activity
          Activity.create!(:user_id => current_user.id,
                           :event_name => 'edit_document_section',
                           :target_id => @document_section.id,
                           :project_id => @document.project.id,
                           :data => {:title => @document_section.title, :doc_title => @document.title,  :doc_url => project_document_path(@project, @document)}
                          )
        rescue
        end

        format.js
      else
        format.js { render :text => :error, :status => 406 }
      end
    end
  end

  def destroy
    @document_section = DocumentSection.find(params[:id])

    respond_to do |format|
      if @document_section.destroy
        format.js
      else
        format.js { render :text => :error, :status => 406 }
      end
    end
  end

  def sort
    params[:document_section].each_with_index do |id, pos|
      DocumentSection.update_all(['position=?', pos + 1], ['id=?', id])
    end

    respond_to do |format|
      format.js { head :ok }
    end
  end
end
