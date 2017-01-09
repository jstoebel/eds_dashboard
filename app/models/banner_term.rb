# == Schema Information
#
# Table name: banner_terms
#
#  BannerTerm    :integer          not null, primary key
#  PlainTerm     :string(45)       not null
#  StartDate     :datetime         not null
#  EndDate       :datetime         not null
#  AYStart       :integer          not null
#  standard_term :boolean
#

class BannerTerm < ActiveRecord::Base
	has_many :adm_tep, foreign_key: "BannerTerm_BannerTerm"
	has_many :adm_st, foreign_key: "BannerTerm_BannerTerm"
	has_many :prog_exit, foreign_key: "ExitTerm"
  has_many :clinical_assignments, foreign_key: "Term"


  scope :actual, lambda {where("BannerTerm > ? and BannerTerm < ?", 1, 999999)}

  def self.current_term(options = {})
    defaults = {
      :exact => true,         #bool, does the date need to match the term perfectly
        #(dates outside of terms are rejected.)
      :plan_b => :forward,    #If not nil, what direction should we look to find the nearest term
        #(if no exact match). Can be foward or back (symbol)
      :date => Date.today   #Date object
    }

    options = defaults.merge(options)

    #try to find the exact term
    term = BannerTerm.where("StartDate<=? and EndDate>=?", options[:date], options[:date]).first

    if term
      return term
    else
      if options[:exact]
        return nil

      else  #go to plan-b
        if options[:plan_b] == :back
          #give me the last term that ended before Date.today
          return BannerTerm.where("EndDate<?", options[:date]).order(EndDate: :desc).order(BannerTerm: :desc).first
        elsif options[:plan_b] == :forward
          #give me the first term that begins after today
          return BannerTerm.where("StartDate>?", options[:date]).order(StartDate: :asc).first
        else
          raise "Must select forward or back for plan_b"
        end
      end
    end
  end

  def next_term(exclusive = false)
    # returns the term with the next largest id
		# exclusive: if the next term should be after the self.EndDate
		if exclusive
			earliest = self.EndDate + 1
			return BannerTerm.where("StartDate >= ?", earliest).order(:StartDate).first
		else
			return BannerTerm.where("BannerTerm > ?", self.BannerTerm).first
		end
  end

  def prev_term(exclusive = false)
    # returns the term with the next smallest id
		# exclusive: if the prev_term should be before the self.StartDate

		if exclusive
			latest = self.StartDate - 1
			return BannerTerm.where("EndDate <= ?", latest).order(:EndDate).last
		else
			return BannerTerm.where("BannerTerm < ?", self.BannerTerm).last
		end
  end

  def readable
    if self.PlainTerm =~ /\d{4}/
      return self.PlainTerm
    else
      return "#{self.PlainTerm} (#{self.AYStart}-#{self.AYStart+1})"
    end
  end

end
