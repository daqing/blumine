class DocumentSectionsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @document = @project.documents.find(params[:document_id])
    @document_section = @document.document_sections.build(params[:document_section])

    respond_to do |f|
      if @document_section.save
        f.html { redirect_to [@project, @document] }
        f.js
      else
        f.html { redirect_to [@project, @document] }
        f.js { render :text => :error, :status => 500 }
      end
    end
  end
end
