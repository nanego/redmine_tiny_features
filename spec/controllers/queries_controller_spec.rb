require "spec_helper"
require 'redmine_tiny_features/queries_controller_patch'
require 'json'
# Re-raise errors caught by the controller.

describe QueriesController, type: :controller do

  fixtures :users, :projects, :members, :roles

  before do
    User.current = User.find(1)
    @request.session[:user_id] = 1 # admin
    2.times do |j|
      10.times do |i|
        User.create!(firstname: "first#{j}name_#{i}", lastname: "lastname#{i}", mail: "#{j}user#{i}@mail.com", password: "password", login: "#{j}login#{i}")
        Member.create!(:user_id => User.last.id, :project_id => 1, :role_ids => [1])
      end
    end
  end

  describe "author_values_pagination" do
    it "should return 21 (20 active users + me ) in the first page whitout search value" do
      get :author_values_pagination, params: {:page_limit => 20, :term => '', :page => 0}

      assert_response :success
      assert_equal 'application/json', response.media_type

      json = JSON.parse(response.body)

      expect(json["results"].count).to eq(3)
      expect(json["results"]).to include({"id"=>"me", "text"=>"<< me >>"})
      expect(json["results"][1]).to eq({"id"=>1, "text"=>"active", "children"=>[]})
      expect(json["results"][2]["children"].count).to eq(20)

    end

    it "should return 6 users (4 active users + 1 user locked + Anonymous ) in the second page whitout search value" do
      get :author_values_pagination, params: {:page_limit => 20, :term => '', :page => 1}

      assert_response :success
      assert_equal 'application/json', response.media_type

      json = JSON.parse(response.body)

      expect(json["results"].count).to eq(4)
      expect(json["results"]).to include({"id"=>"6", "text"=>"Anonymous"})
      expect(json["results"][0]["children"].count).to eq(4)
      expect(json["results"][1]).to eq({"id"=>2, "text"=>"locked", "children"=>[]})
      expect(json["results"][2]["children"][0]).to eq({"id"=>"5", "text"=>"Dave2 Lopper2"})
      expect(json["results"][3]).to eq({"id"=>"6", "text"=>"Anonymous"})
    end

    it "should return 10 users whose names are like the search value in the first page" do
      get :author_values_pagination, params: {:page_limit => 20, :term => 'first1', :page => 0}

      assert_response :success
      assert_equal 'application/json', response.media_type

      json = JSON.parse(response.body)

      expect(json["results"].count).to eq(2)
      expect(json["results"][0]).to eq({"id"=>1, "text"=>"active", "children"=>[]})
      expect(json["results"][1]["children"].count).to eq(10)
      expect(json["results"][1]["children"][0]["text"]).to eq("first1name_0 lastname0")
    end

    it "should return users whose names are like the search value with both firstname and name" do
      get :author_values_pagination, params: {:page_limit => 20, :term => 'first1name_0 last', :page => 0}

      assert_response :success
      assert_equal 'application/json', response.media_type

      json = JSON.parse(response.body)

      expect(json["results"].count).to eq(2)
      expect(json["results"][0]).to eq({"id"=>1, "text"=>"active", "children"=>[]})
      expect(json["results"][1]["children"].size).to eq 1
      expect(json["results"][1]["children"][0]["text"]).to eq("first1name_0 lastname0")
    end

    it "should return users whose names are like the search value with both firstname and name in reverse order" do
      get :author_values_pagination, params: {:page_limit => 20, :term => 'lastname0 first1name_0', :page => 0}

      assert_response :success
      assert_equal 'application/json', response.media_type

      json = JSON.parse(response.body)

      expect(json["results"].count).to eq(2)
      expect(json["results"][0]).to eq({"id"=>1, "text"=>"active", "children"=>[]})
      expect(json["results"][1]["children"].size).to eq 1
      expect(json["results"][1]["children"][0]["text"]).to eq("first1name_0 lastname0")
    end
  end

  describe "assigned_to_values_pagination" do
    it "should return 21 (20 active users + me ) in the first page whitout search value" do
      get :assigned_to_values_pagination, params: {:page_limit => 20, :term => '', :page => 0}

      assert_response :success
      assert_equal 'application/json', response.media_type

      json = JSON.parse(response.body)

      expect(json["results"].count).to eq(3)
      expect(json["results"]).to include({"id"=>"me", "text"=>"<< me >>"})
      expect(json["results"][1]).to eq({"id"=>1, "text"=>"active", "children"=>[]})
      expect(json["results"][2]["children"].count).to eq(20)

    end

    it "should return 5 users (4 active users + 1 user locked) in the second page whitout search value" do
      get :assigned_to_values_pagination, params: {:page_limit => 20, :term => '', :page => 1}

      assert_response :success
      assert_equal 'application/json', response.media_type

      json = JSON.parse(response.body)

      expect(json["results"].count).to eq(3)
      expect(json["results"][0]["children"].count).to eq(4)
      expect(json["results"][1]).to eq({"id"=>2, "text"=>"locked", "children"=>[]})
      expect(json["results"][2]["children"][0]).to eq({"id"=>"5", "text"=>"Dave2 Lopper2"})
    end

    it "should return 10 users whose names are like the search value in the first page" do
      get :author_values_pagination, params: {:page_limit => 20, :term => 'first0', :page => 0}

      assert_response :success
      assert_equal 'application/json', response.media_type

      json = JSON.parse(response.body)

      expect(json["results"].count).to eq(2)
      expect(json["results"][0]).to eq({"id"=>1, "text"=>"active", "children"=>[]})
      expect(json["results"][1]["children"].count).to eq(10)
      expect(json["results"][1]["children"][0]["text"]).to eq("first0name_0 lastname0")
    end
  end

end

