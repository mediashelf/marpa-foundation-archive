require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "active_fedora"
require "nokogiri"

describe HydrangeaArticle do
  
  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @article = HydrangeaArticle.new
    @article.stubs(:apply_ldap_values)
    @file_asset = FileAsset.new
  end

  describe "apply default permissions" do
    it "should have UVA and public access set to read" do
      rights_ds = @article.datastreams_in_memory["rightsMetadata"]
      rights_ds.get_values([:read_access, :group]).should == []       
    end
  end
  
  describe "apply default license" do
    it "should have UVA and CC license set" do
      rights_ds = @article.datastreams_in_memory["rightsMetadata"]
      rights_ds.get_values([:copyright, :uvalicense]).should == ["no"]       
      #rights_ds.get_values([:copyright, :cclicense]).should == ["yes"]             
    end
  end  
  
  describe "insert_contributor" do
    it "should generate a new contributor of type (type) into the current xml, treating strings and symbols equally to indicate type, and then mark the datastream as dirty" do
      mods_ds = @article.datastreams_in_memory["descMetadata"]
      mods_ds.expects(:insert_contributor).with("person",{})
      node, index = @article.insert_contributor("person")
    end
  end
  
  describe "remove_contributor" do
    it "should remove the corresponding contributor from the xml and then mark the datastream as dirty" do
      mods_ds = @article.datastreams_in_memory["descMetadata"]
      mods_ds.expects(:remove_contributor).with("person","3")
      node, index = @article.remove_contributor("person", "3")
    end
  end
  
  describe "apply_depositor_metadata" do
    it "should set depositor info in the properties and rightsMetadata datastreams" do
      rights_ds = @article.datastreams_in_memory["rightsMetadata"]
      prop_ds = @article.datastreams_in_memory["properties"]

      node, index = @article.apply_depositor_metadata("Depositor Name")
      
      prop_ds.depositor_values.should == ["Depositor Name"]
      rights_ds.get_values([:edit_access, :person]).should == ["Depositor Name"]
    end
  end
  
  describe ".to_solr" do
    it "should return the necessary facets" do
      @article.update_indexed_attributes({[{:person=>0}, :institution]=>"my org", [:subject, :topic]=>["subject1", "subject2"]}, :datastreams=>"descMetadata")
      solr_doc = @article.to_solr
      solr_doc.should have_solr_fields("person_institution_t" => "my org")        
      solr_doc.should have_solr_fields("person_institution_facet" => "my org")        
      solr_doc.should have_solr_fields("subject_topic_facet" => ["subject1", "subject2"])        
      solr_doc.should have_solr_fields("topic_tag_facet" =>  ["subject1", "subject2"])               
    end
    describe "placeholder release workflow" do
      before(:each) do
        @ready_to_release = HydrangeaArticle.new
        @ready_to_release.datastreams["properties"].released_values = "true"
        @ready_to_release.datastreams["descMetadata"].update_indexed_attributes({[:title_info, :main_title]=>"my title", [{:person=>0}, :last_name]=>"author_last_name", [{:person=>0}, :role, :text]=>"Author"})
        @ready_to_release.stubs(:parts).returns([@file_asset])
      end
      it "should not grant public access until released" do
        @article.to_solr.should_not have_solr_fields("read_access_group_t"=>"public")
        @article.to_solr.should_not have_solr_fields("read_access_group_t"=>"registered")
      end
      it "should not release until a file is uploaded and author & title are set" do
        @article.datastreams["properties"].released_values = "true"
        @article.to_solr.should_not have_solr_fields("read_access_group_t"=>"public")
        @article.datastreams["properties"].released_values = "true"
        @article.to_solr.should_not have_solr_fields("read_access_group_t"=>"public")
        @article.datastreams["descMetadata"].update_indexed_attributes({[:title_info, :main_title]=>"my title", [{:person=>0}, :last_name]=>"author_last_name", [{:person=>0}, :role, :text]=>"Author"})
        @article.to_solr.should_not have_solr_fields("read_access_group_t"=>"public")
        @article.stubs(:parts).returns([@file_asset])
        # adding for UVa Libra implementation
        @article.datastreams["properties"].release_to_values = "public"
        @article.to_solr.should have_solr_fields("read_access_group_t"=>"public")
      end
      it "should support releasing for the general public" do
        @ready_to_release.datastreams["properties"].release_to_values = "public"
        @ready_to_release.datastreams["properties"].released_values = "true"
        @ready_to_release.to_solr.should have_solr_fields("read_access_group_t"=>"public")
      end
      it "should support releasing for logged in (registered) users" do
        # replaced registered with uva for Libra OA implementation
        @ready_to_release.datastreams["properties"].release_to_values = "uva"
        @ready_to_release.datastreams["properties"].released_values = "true"
        @ready_to_release.to_solr.should have_solr_fields("read_access_group_t"=>["uva"])
        @ready_to_release.to_solr.should_not have_solr_fields("read_access_group_t"=>["public"])

      end
    end
  end
end
