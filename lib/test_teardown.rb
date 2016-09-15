require 'fileutils'

module TestTeardown
    def teardown
        #rm -rf public/student_files/test
        FileUtils.rm_rf('public/student_files/test')
        FileUtils.rm_rf('test/test_temp')        
    end
end
