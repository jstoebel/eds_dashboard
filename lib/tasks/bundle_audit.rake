require Rails.root.join('app', 'mailers', 'application_mailer')
if Rails.env.development? || Rails.env.test?
  require 'bundler/audit/scanner'
  include Bundler::Audit
  namespace :bundler do
    desc 'Updates the ruby-advisory-db and runs audit'
    task :audit => :environment do
      scanner = Bundler::Audit::Scanner.new
      vulnerabilities = 0
      insecure_source = []
      unpatched_gems = []
      scanner.scan do |result|
        vulnerabilities += 1

        case result
        when Scanner::InsecureSource
          insecure_source << result.source
        when Scanner::UnpatchedGem
          unpatched_gems << result.gem
        end
      end # scanner

      if vulnerabilities > 0
        email = AdminMailer.gem_security_alert(unpatched_gems.uniq, insecure_source.uniq)
        email.deliver_now
        puts "#{vulnerabilities} vulnerabilities found!"
        puts unpatched_gems
        puts insecure_source
        fail "#{vulnerabilities} vulnerabilities found!"
      else
        puts "no vulnerabilities found"
      end

    end # task

  end
end
