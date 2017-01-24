class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is? "admin"

      # can :access, :rails_admin       # only allow admin users to access Rails Admin
      # can :dashboard

      can :manage, :all
      can :import, :all

    elsif user.is? "advisor"

      can :manage, [Issue, IssueUpdate, StudentFile, ClinicalAssignment, Pgp, PgpScore, Student] do |resource|
        #map the resource to the student. If the student is assigned to the prof as an advisee or

        advisor_check(user, resource)
      end

      cannot :report, Student

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
      can [:write, :read, :report], Student
      can [:index, :create, :update, :delete, :destroy], PraxisResult

    elsif user.is? "student labor"
      # can :index, Student
      can :read, Student
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

      if resource.kind_of? Student   #if the resource is a student object
        stu=resource
      else
        stu = resource.student      #all other resources
      end
      return false if stu.blank? # if resource has no student
      return (stu.is_advisee_of(advisor_profile) || stu.is_student_of?(advisor_profile.AdvisorBnum))

    else  #user not in advisor table
      return false
    end

  end

end
