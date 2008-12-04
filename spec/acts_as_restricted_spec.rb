require File.dirname(__FILE__) + '/spec_helper'

describe ActsAsRestricted do
  
  describe "restrict items on group" do
    
    it "should be set as restricted" do
      Item.new.restricted?.should == true
      #puts Item.restricted.find(:all)
    end

    it "should set scoped_options dynamically" do
      #puts Item.restricted.proxy_options

      group = Group.new(:name => "my group", :user_id => 1)
      group.save

      item = Item.new(:name => "my item", :group_id => group.id)
      item.save

      i = Item.find(:all).first
      i.name = "test"
      i.save.should == true
    
      i = Item.restricted.find(:all).first
      i.name = "test"
      lambda { i.save }.should raise_error(ActiveRecord::ReadOnlyRecord)
   end
  end

end
