class Ability
  include CanCan::Ability

  def initialize(user)

    #TODO define specific records a user has permission to 
    #https://github.com/ryanb/cancan/wiki/Defining-Abilities#hash-of-conditions

    if user.is? "admin"
      can :manage, :all

    elsif user.is? "advisor"
      can :manage, [Issue, IssueUpdate, StudentFile]
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
