require 'spec_helper'
describe "The CVE-2015-7576 vulnerability" do
	before(:all) do
		@check = Dawn::Kb::CVE_2015_7576.new
		@check.debug = true
	end
	it "is reported when the vulnerable gem is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"5.0.0.beta.1"}]
		expect(@check.vuln?).to   eq(true)
	end
	it "is reported when the vulnerable gem is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"4.2.5"}]
		expect(@check.vuln?).to   eq(true)
	end
	it "is reported when the vulnerable gem is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"4.1.14"}]
		expect(@check.vuln?).to   eq(true)
	end
	it "is reported when the vulnerable gem is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"3.2.22"}]
		expect(@check.vuln?).to   eq(true)
	end
	it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"5.0.0"}]
		expect(@check.vuln?).to   eq(false)
	end
	it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"4.2.5.1"}]
		expect(@check.vuln?).to   eq(false)
	end
	it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"4.2.6"}]
		expect(@check.vuln?).to   eq(false)
	end
	it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"4.1.14.2"}]
		expect(@check.vuln?).to   eq(false)
	end
	it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"4.1.15"}]
		expect(@check.vuln?).to   eq(false)
	end
	it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"3.2.22.1"}]
		expect(@check.vuln?).to   eq(false)
	end
	it "is not reported when a fixed release is detected" do
    @check.dependencies = [{:name=>"actionpack", :version=>"3.2.23"}]
		expect(@check.vuln?).to   eq(false)
	end
end
