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

  def another_method
    case X; when 1; A; when 2; B; when 3; C; when 4; D end
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
    @source.total_lines.should == 25
  end

  it "calculates the number of empty lines" do
    @source.empty_lines.should == 4
  end
  it "calculates the number of commented lines" do
    @source.comment_lines.should == 2
  end

  it "calculates the cyclomatic complexity index" do
    @source.cyclomatic_complexity.should == 6
  end

  it "autodetect the kind of source" do
    @source.auto_detect.should == :class
  end

  it "tells me there are 4 methods in this class" do
    @source.methods_count.should == 4
  end

end
