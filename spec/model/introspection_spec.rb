# encoding: utf-8
require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Her::Model::Introspection do
  context "introspecting a resource" do
    before do # {{{
      Her::API.setup :base_uri => "https://api.example.com"
      FakeWeb.register_uri(:get, "https://api.example.com/users/1", :body => { :id => 1, :name => "Tobias Fünke" }.to_json)
      spawn_model :User
    end # }}}

    describe "#inspect" do
      it "outputs resource attributs for an existing resource" do # {{{
        @user = User.find(1)
        @user.inspect.should == "#<User(/users/1) id=1 name=\"Tobias Fünke\">"
      end # }}}

      it "outputs resource attributs for an not-saved-yet resource" do # {{{
        @user = User.new(:name => "Tobias Fünke")
        @user.inspect.should == "#<User(/users) name=\"Tobias Fünke\">"
      end # }}}
    end
  end
end
