require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  setup do
    log_in(:two)
    @project = projects(:blumine)
    @document = documents(:two)
  end
  
  test "should get new" do
    get :new, :project_id => @project.id
    assert_response :success
    assert_select 'form.new_document'
  end
  
  test "should create document" do
    assert_difference('Document.count') do
      create_document
    end
    
    assert_redirected_to [assigns(:project), assigns(:document)]
  end
  
  test "should edit document" do
    get :edit, :project_id => @project.id, :id => @document.id
    assert_response :success
    assert_select 'form.edit_document'
  end
  
  test "should update document" do
    new_title = @document.title * 2
    post :update, :project_id => @project.id, :id => @document.id, :document => {:title => @document.title * 2, :content => @document.content}
    assert_equal assigns(:document).title, new_title
    assert_redirected_to [assigns(:project), assigns(:document)]
  end
  
  test "should destroy document" do
    assert_difference('Document.count', -1) do
      delete :destroy, :project_id => @project.id, :id => @document.id
    end
    assert_redirected_to assigns(:project)
  end
  
  test "should create activity" do
    assert_difference('Activity.count') do
      create_document
    end
  end
  
  test "only creator can manage document" do
    relog_in(:nana)
    get :edit, :project_id => @project.id, :id => @document.id
    assert_no_permission
  end
  
  private
    def create_document
      post :create, :project_id => @project.id, :document => {:title => 'foo', :content => 'bar'}
    end
end
