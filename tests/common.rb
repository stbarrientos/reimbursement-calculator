# In an effort to keep this script as light weight as possible, I'm not going to include any testing frameworks.
# A simple sanity test class is plenty.
class TestSuite
  Test = Struct.new(:name, :block)

  def initialize
    @tests = []
  end

  def test(name, &block)
    @tests << Test.new(name, block)
  end

  # Convenience method for skipping tests
  def xtest(name, &block); end

  def run
    # These tests are incredibly simple, if they evaluate to false, they are failures
    failed_tests = @tests.select { |test| !test.block.call }

    if failed_tests.empty?
      puts "All tests passed"
      return
    end

    puts "Failed tests:"
    failed_tests.each { |test| puts test.name }
  end
end
