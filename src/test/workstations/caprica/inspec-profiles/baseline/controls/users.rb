title 'audit users setup'

control 'default_user' do
    impact 1.0
    title 'Validate the default user and its ssh keys'
    desc 'Ensure the default user is present and correctly set up'

    describe user('seb') do
        it { should exist }
        its('groups') { should cmp ['seb', 'adm', 'sudo', 'vagrant', 'docker']}
        its('home') { should cmp '/home/seb' }
        its('shell') { should cmp '/bin/bash' }
    end

    describe file('/home/seb/.ssh/authorized_keys') do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }

        it { should be_readable.by('owner') }
        it { should be_readable.by('group') }
        it { should be_readable.by('others') }

        it { should be_writable.by('owner') }
        it { should_not be_writable.by('group') }
        it { should_not be_writable.by('others') }

        it { should_not be_executable }

        it { should be_owned_by 'seb' }
        it { should be_grouped_into 'seb' }
    end

    describe file('/home/seb/.ssh/id_rsa') do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }

        it { should be_readable.by('owner') }
        it { should_not be_readable.by('group') }
        it { should_not be_readable.by('others') }

        it { should be_writable.by('owner') }
        it { should_not be_writable.by('group') }
        it { should_not be_writable.by('others') }

        it { should_not be_executable }

        it { should be_owned_by 'seb' }
        it { should be_grouped_into 'seb' }
    end

    describe file('/home/seb/.ssh/id_rsa.pub') do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }

        it { should be_readable.by('owner') }
        it { should be_readable.by('group') }
        it { should be_readable.by('others') }

        it { should be_writable.by('owner') }
        it { should_not be_writable.by('group') }
        it { should_not be_writable.by('others') }

        it { should_not be_executable }

        it { should be_owned_by 'seb' }
        it { should be_grouped_into 'seb' }
    end

    describe file('/home/seb/.ssh/kobol_id_rsa.pub') do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }

        it { should be_readable.by('owner') }
        it { should be_readable.by('group') }
        it { should be_readable.by('others') }

        it { should be_writable.by('owner') }
        it { should_not be_writable.by('group') }
        it { should_not be_writable.by('others') }

        it { should_not be_executable }

        it { should be_owned_by 'seb' }
        it { should be_grouped_into 'seb' }
    end
end
