require 'spec_helper'
describe "The OSVDB_117903 vulnerability" do
	before(:all) do
		@check = Dawn::Kb::OSVDB_117903.new
		# @check.debug = true
	end
  it "is reported when the vulnerable gem is detected" do
    @check.dependencies = [{:name=>"ruby-saml", :version=>"0.7.2"}]
    expect(@check.vuln?).to   eq(true)
  end
  it "is reported when the vulnerable gem is detected" do
    @check.dependencies = [{:name=>"ruby-saml", :version=>"0.8.1"}]
    expect(@check.vuln?).to   eq(true)
  end
  it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"ruby-saml", :version=>"0.7.3"}]
    expect(@check.vuln?).to   eq(false)
  end
  it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"ruby-saml", :version=>"0.8.2"}]
    expect(@check.vuln?).to   eq(false)
  end
end
