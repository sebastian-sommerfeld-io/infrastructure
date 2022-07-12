title "audit users setup"

control "default_user" do
    impact 1.0
    title "Validate the default user and its ssh keys"
    desc "Ensure the default user is present and correctly set up"

    describe user('starbuck') do
        it { should exist }
        its('groups') { should cmp ['starbuck', 'adm', 'sudo', 'vagrant', 'docker']}
        its('home') { should cmp '/home/starbuck' }
        its('shell') { should cmp '/bin/bash' }
    end

    describe file("/home/starbuck/.ssh/id_rsa") do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
    end

    describe file("/home/starbuck/.ssh/id_rsa.pub") do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
    end

    describe file("/home/starbuck/.ssh/kobol_id_rsa.pub") do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
    end

    # describe key_rsa('/home/starbuck/.ssh/id_rsa') do
    #     it { should be_private }
    #     it { should be_public }
    #     its('public_key') { should match "-----BEGIN PUBLIC KEY-----\n3597459df9f3982" }
    #     its('key_length') { should eq 2048 }
    # end
end