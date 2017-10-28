require 'spec_helper'
describe "The CVE-2014-0036 vulnerability" do
	before(:all) do
		@check = Dawn::Kb::CVE_2014_0036.new
		# @check.debug = true
	end
  it "is reported when a vulnerable rbovirt gem version is detected (0.0.23)" do
    @check.dependencies = [{:name=>"rbovirt", :version=>'0.0.23'}]
    expect(@check.vuln?).to   eq(true)
  end
  it "is not reported when a sage rbovirt gem version is detected (0.0.24)" do
    @check.dependencies = [{:name=>"rbovirt", :version=>'0.0.24'}]
    expect(@check.vuln?).to   eq(false)
  end
end
