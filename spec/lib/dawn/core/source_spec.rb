require 'spec_helper'



describe "The Codesake::Dawn::Core::Source class" do
  before(:all) do
    @content=<<EOF
class Test

  def initialize
    @a = 23 + 19
  end

  # This is a line of comment
  def plus
    @a += 0
  end

  # This is a bogus method to increase cyclomatic complexity index
  def a_nonsense_method
   if @a > 23
    puts "hello"
   else
     # foo here
     puts "here"
   end
  end
end
EOF
  File.open("./test.rb", "w") do |f|
    f.puts @content
    end

    @source = Codesake::Dawn::Core::Source.new({:filename=>"./test.rb", :debug=>true})
  end
  after(:all) do
    File.delete("./test.rb")
  end
  it "calculates the number of lines of code" do
    @source.stats[:total_lines].should == 21
  end

  it "calculates the number of empty lines" do
    @source.stats[:empty_lines].should == 3
  end
  it "calculates the number of commented lines" do
    @source.stats[:comment_lines].should == 2
  end

  it "calculates the cyclomatic complexity index" do
    @source.stats[:cyclomatic_complexity].should == 3
  end

end
