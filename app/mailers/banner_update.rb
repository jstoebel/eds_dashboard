class BannerUpdate < ApplicationMailer

  def notify_possible_drop(stu)
    # stu (Student object)
    # notifies all TEP_advisors related to stu about possible drop

    advisors = stu.tep_advisors
    

  end
end
