require 'spec_helper'

# Great coverage about how to deal with SSL in your ruby code, you can find it
# here: http://mislav.uniqpath.com/2013/07/ruby-openssl/
#
# Parsing a line like "http.verify_mode = OpenSSL::SSL::VERIFY_NONE" results in
# the folliwing AST: s(:attrasgn, s(:call, nil, :http), :verify_mode=,
# s(:colon2, s(:colon2, s(:const, :OpenSSL), :SSL), :VERIFY_NONE))



describe "The SSL Verification bypass vulnerability" do
  before(:all) do
    @source1=<<EOF
require 'net/https'
require 'net/http'

uri = URI.parse("https://www.yourDomain.gov/")

request = Net::HTTP.new(uri.host, uri.port)
request.use_ssl = true
request.verify_mode = OpenSSL::SSL::VERIFY_NONE
response = request.get("/")

response.body.size
EOF

    File.open("./open_uri_with_ssl.rb", "w") do |f|
      f.puts @source1
    end

    @source = Codesake::Dawn::Core::Source.new({:filename=>"./open_uri_with_ssl.rb", :debug=>true})
    @check = Codesake::Dawn::Kb::SSLVerificationBypass.new
  end
  after(:all) do
    File.delete("./open_uri_with_ssl.rb")
  end

  context "if in the code we use ssl" do

    it "fires when you assign OpenSSL::SSL::VERIFY_NONE to a Net::HTTP class variable"
    it "fires when you make this assignment OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE"
    it "fires when you open an uri this way: open(uri,:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)"
    it "fires when you open an uri this way: open(request_uri, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})"
  end
  context "if in the code we don't use ssl" do
    it "doesn't fire when you assign OpenSSL::SSL::VERIFY_NONE to a Net::HTTP class variable"
    it "doesnt' fire when you make this assignment OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE"
    it "doesnt' fire when you open an uri this way: open(uri,:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)"
    it "doesnt' fire when you open an uri this way: open(request_uri, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})"

  end

end
