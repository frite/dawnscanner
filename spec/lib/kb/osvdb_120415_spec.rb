require 'spec_helper'
describe "The OSVDB_120415 vulnerability" do
	before(:all) do
		@check = Dawn::Kb::OSVDB_120415.new
		# @check.debug = true
	end
  it "is reported when the vulnerable gem is detected" do
    @check.dependencies = [{:name=>"redcarpet", :version=>"3.2.2"}]
    expect(@check.vuln?).to   eq(true)
  end
  it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"redcarpet", :version=>"3.2.3"}]
    expect(@check.vuln?).to   eq(false)
  end

end
