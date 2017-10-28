require 'spec_helper'
describe "The CVE-2014-3483 vulnerability" do
	before(:all) do
		@check = Dawn::Kb::CVE_2014_3483.new
		@check.debug = true
	end
  it "is reported when a rails gem version 4.0.6 is detected" do
    @check.dependencies = [{:name=>"rails", :version=>"4.0.6"}]
    expect(@check.vuln?).to   eq(true)
  end
  it "is reported when a rails gem version 4.1.2 is detected" do
    @check.dependencies = [{:name=>"rails", :version=>"4.1.2"}]
    expect(@check.vuln?).to   eq(true)
  end
  it "is not reported when a rails gem version 4.0.7 is detected" do
    @check.dependencies = [{:name=>"rails", :version=>"4.0.7"}]
    expect(@check.vuln?).to   eq(false)
  end
  it "is not reported when a rails gem version 4.1.3 is detected" do
    @check.dependencies = [{:name=>"rails", :version=>"4.1.3"}]
    expect(@check.vuln?).to   eq(false)
  end
  it "is not reported when a rails gem version 3.2.21 is detected" do
    @check.dependencies = [{:name=>"rails", :version=>"3.2.21"}]
    expect(@check.vuln?).to   eq(false)
  end
end
