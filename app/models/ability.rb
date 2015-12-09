class Ability
  include CanCan::Ability

  def initialize(user)

    #TODO define specific records a user has permission to 
    #https://github.com/ryanb/cancan/wiki/Defining-Abilities#hash-of-conditions

    if user.is? "admin"
      can :manage, :all

    elsif user.is? "advisor"
      can :manage, [Issue, IssueUpdate, StudentFile] do |resource|
        #map the resource to the student. If the student is assigned to the prof as an advisee or 
        #student, return true

        advisor_profile = user.tep_advisor

        if advisor_profile.present?   #is user in the advisor table (admin posing as advisor might not)
          bnum = advisor_profile.AdvisorBnum
          stu = resource.student

          if stu.is_advisee_of(bnum) or stu.is_student_of(bnum)
            return true   #user has this student as an advisee
          else
            return false    #user has this student in a current course
          end

        else  #user not in advisor table
          return false
        end

      end
      can :read, [Student, PraxisResult, PraxisSubtestResult]

    elsif user.is? "staff"
      can :manage, [AdmSt, AdmTep, AlumniInfo, ClinicalAssignment, ClinicalSite, ClinicalTeacher, 
        Employment, Foi, ProgExit, StudentFile]
      can [:new, :create], PraxisResult
      can :read, Student

    elsif user.is? "student labor"
      can :manage, [ClinicalAssignment, ClinicalTeacher, ClinicalSite]
      can [:new, :create], PraxisResult
      can [:index, :new, :create, :delete, :destroy], StudentFile   #everything but download!
    end
    
  end
end
