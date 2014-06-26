require 'spec_helper'

# Great coverage about how to deal with SSL in your ruby code, you can find it
# here: http://mislav.uniqpath.com/2013/07/ruby-openssl/
#
# Parsing a line like "http.verify_mode = OpenSSL::SSL::VERIFY_NONE" results in
# the folliwing AST: s(:attrasgn, s(:call, nil, :http), :verify_mode=,
# s(:colon2, s(:colon2, s(:const, :OpenSSL), :SSL), :VERIFY_NONE))

describe "The SSL Verification bypass vulnerability" do

end
