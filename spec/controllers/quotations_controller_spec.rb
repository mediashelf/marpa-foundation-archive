require 'spec_helper'

describe QuotationsController do
  before do
    @talk = Talk.new()
    @talk.english_title='This modern world'
    @talk.save
  end

  describe "create action" do
    it "should assign the talk and a new quotation" do
      post :create, {:talk => @talk.pid}
      assigns(:talk).english_title.should == 'This modern world'
      assigns(:quotation).persisted?.should be true
      response.should redirect_to(edit_quotation_path(assigns(:quotation), :talk=>assigns(:talk)))
    end
  end

  describe "edit action" do

    before do
      @user = User.new(:email=>"archivist@example.com")
      controller.stubs(:current_user).returns(@user)
      @quote = Quotation.new()
      @quote.english_title='Rolling in the deep'
      @quote.apply_depositor_metadata(@user.login)
      @quote.save
    end
    it "should assign the quotation" do
      get :edit, :id => @quote.pid
      assigns(:quotation).pid.should == @quote.pid
      response.should render_template 'edit'
    end
    after do
      @quote.delete
    end
  end

  describe "update action" do
    before do
      @quote = Quotation.new()
      @quote.english_title='Trying your luck'
      @quote.save
    end
    it "should assign the quotation" do
      put :update, :id => @quote.pid, :quotation=>{:english_title=>"Far and away"}, :talk=>@talk.pid
      Quotation.find(@quote.pid).english_title.should == "Far and away"
      response.should redirect_to edit_talk_path(@talk)
    end
    after do
      @quote.delete
    end
  end


  after do
    @talk.delete
  end

end
