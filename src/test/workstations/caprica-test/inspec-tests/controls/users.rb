title "audit users setup"

control "default_user" do
    impact 1.0
    title "Validate the default user"
    desc "Ensure the default user is present and correctly set up"

    describe user('starbuck') do
        it { should exist }
        its('groups') { should cmp ['starbuck', 'adm', 'sudo', 'vagrant', 'docker']}
        its('home') { should cmp '/home/starbuck' }
        its('shell') { should cmp '/bin/bash' }
    end
end