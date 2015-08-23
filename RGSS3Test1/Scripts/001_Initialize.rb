$stderr.reopen("stderr.txt")
$stdout.reopen("stdout.txt")

class AssertionFailedError < StandardError
end

def assert_block(message = "assert_block failed.", &b)
  if !b.call then
    raise AssertionFailedError, message
  end
end
def assert_raise(*args, &b)
  message = nil
  if String === args.last then
    message = args.pop
  end
  begin
    b.call
  rescue
    if args.any? {|k| $!.kind_of?(k) } then
      return
    end
  end
  raise AssertionFailedError, message
end
def assert(boolean, message = nil)
  if !boolean then
    raise AssertionFailedError, message
  end
end
def assert_equal(expected, actual, message = nil)
  if expected != actual then
    raise AssertionFailedError, message
  end
end
def assert_not_equal(expected, actual, message = nil)
  if expected == actual then
    raise AssertionFailedError, message
  end
end
def assert_same(expected, actual, message = nil)
  if !expected.equal?(actual) then
    raise AssertionFailedError, message
  end
end
def assert_not_same(expected, actual, message = nil)
  if expected.equal?(actual) then
    raise AssertionFailedError, message
  end
end

def run_test(klass)
  puts "Running tests #{klass.name}..."
  i = klass.new
  allcnt = 0
  successcnt = 0
  i.methods.grep(/\Atest_/).each do|method_name|
    ok = true
    begin
      i.send(method_name)
    rescue
      ok = false
    end
    if ok
      puts "  #{method_name}: OK"
      successcnt += 1
    else
      puts "  #{method_name}: Failed"
    end
    allcnt += 1
  end
  puts "Summary: #{successcnt} / #{allcnt}"
  puts ""
end
