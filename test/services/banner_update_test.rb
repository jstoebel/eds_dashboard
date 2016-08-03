require 'test_helper'

class BannerUpdateTaskTest < ActiveSupport::TestCase

  setup do
    conn = BannerConnection.new 201511
    

    conn.stubs(:get_results).returns("I was stubbed!")
  end

  test "returns some data" do
    conn = BannerConnection.new 201511
    conn.stubs(:get_results).returns("I was stubbed!")
    assert_equal conn.get_results, "I was stubbed!"
  end

end
