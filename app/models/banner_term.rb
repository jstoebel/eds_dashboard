class BannerTerm < ActiveRecord::Base
	has_many :adm_tep, foreign_key: "BannerTerm_BannerTerm"
	has_many :adm_st, foreign_key: "BannerTerm_BannerTerm"
	has_many :prog_exit, foreign_key: "ExitTerm"


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

end
