class Ability
  include CanCan::Ability

  def initialize(user)


    if user.is? "admin"
      can :manage, :all

    elsif user.is? "advisor"

      can :manage, [Issue, IssueUpdate, StudentFile, ClinicalAssignment, Pgp, PgpScore] do |resource|
        #map the resource to the student. If the student is assigned to the prof as an advisee or

        #student, return true
        advisor_check(user, resource)
      end

      can :be_concerned, Student do |resource| #permission to be used in the concerns_dashboard
        advisor_check(user, resource)
      end

      can :manage, [ClinicalTeacher, ClinicalSite]

      can :read, [Student, PraxisResult, PraxisSubtestResult] do |resource|
        advisor_check(user, resource)
      end

    elsif user.is? "staff"
      can :manage, [AdmSt, AdmTep, AlumniInfo, ClinicalAssignment, ClinicalSite, ClinicalTeacher,
        Employment, Foi, ProgExit, StudentFile]
      can [:index, :create, :update, :delete, :destroy], PraxisResult
      can :read, [Student]
    elsif user.is? "student labor"
      can :index, Student
      can :manage, [ClinicalAssignment, ClinicalTeacher, ClinicalSite]
      can [:index, :create, :update, :delete, :destroy], PraxisResult
      can [:index, :new, :create, :delete, :destroy], StudentFile   #everything but download!
    end

  end

  private
  def advisor_check(user, resource)
    # is user an advisor or professor of this the student  or student belonging to this resource?

    advisor_profile = user.tep_advisor

    if advisor_profile.present?   #is user in the advisor table (admin posing as advisor might not)

      if resource.kind_of?Student   #if the resource is a student object
        stu=resource
      else
        stu = resource.student      #all other resources
      end

      return (stu.is_advisee_of(advisor_profile) or stu.is_student_of?(advisor_profile.AdvisorBnum))

    else  #user not in advisor table
      return false
    end

  end

end
