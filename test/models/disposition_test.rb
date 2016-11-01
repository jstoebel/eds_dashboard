# == Schema Information
#
# Table name: dispositions
#
#  id               :integer          not null, primary key
#  disp_code        :string(255)
#  disp_description :text(65535)
#  current          :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class DispositionTest < ActiveSupport::TestCase

  describe "validations" do
    before do
      @disp = FactoryGirl.create :disposition
    end
    test "code" do
      @disp.code = nil
      assert_not @disp.valid?
      assert_equal ["Disposition must have a code (example 1.1)"], @disp.errors[:code]
    end

    test "description" do
      @disp.description = nil
      assert_not @disp.valid?
      assert_equal ["Disposition must have a description"], @disp.errors[:description]
    end

    test "current" do
      @disp.current = nil
      assert_not @disp.valid?
      assert_equal ["Disposition must be marked as current or not current"], @disp.errors[:current]
    end

  end

  test "current scope" do
    FactoryGirl.create_list :disposition, 5
    assert_equal Disposition.where(current: true).to_a, Disposition.current.to_a
  end

  test "ordered scope" do
    FactoryGirl.create_list :disposition, 5
    assert_equal Disposition.order(:code).to_a, Disposition.ordered.to_a
  end

end
