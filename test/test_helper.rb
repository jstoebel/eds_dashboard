ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  self.set_fixture_class adm_tep: AdmTep,
							banner_terms: BannerTerm
  # Add more helper methods to be used by all tests here...

  def py_assert(expected, actual)
  	#an assertion in the style of python unittest. 
  	#Two arguments are compared, and the error message is automaticlaly populated
    assert(expected==actual, "Expected value #{expected} does not equal #{actual}.")
  end
end
