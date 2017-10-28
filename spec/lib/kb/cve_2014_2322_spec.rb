require 'spec_helper'
describe "The CVE-2014-2322 vulnerability" do
	before(:all) do
		@check = Dawn::Kb::CVE_2014_2322.new
		# @check.debug = true
	end
  it "is reported when a vulnerable arabic prawn gem version is found (0.0.1)" do
    @check.dependencies = [{:name=>"Arabic-Prawn", :version=>'0.0.1'}]
    expect(@check.vuln?).to   eq(true)
  end
  it "is not reported when a sage vulnerable arabic prawn gem version is found (0.0.2)" do
    @check.dependencies = [{:name=>"Arabic-Prawn", :version=>'0.0.2'}]
    expect(@check.vuln?).to   eq(false)
  end
end
