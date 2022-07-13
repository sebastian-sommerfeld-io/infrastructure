title 'audit software packages'

control 'required-system-packages' do
    impact 1.0
    title 'Validate software package installations'
    desc 'Ensure packages are installed'

    describe package('apt-transport-https') do
        it { should be_installed }
    end

    describe package('ca-certificates') do
        it { should be_installed }
    end

    describe package('curl') do
        it { should be_installed }
    end

    describe package('software-properties-common') do
        it { should be_installed }
    end

    describe package('python3-pip') do
        it { should be_installed }
    end

    describe package('python3-setuptools') do
        it { should be_installed }
    end

    describe package('virtualenv') do
        it { should be_installed }
    end
end

control 'tools-packages' do
    impact 1.0
    title 'Validate software package installations'
    desc 'Ensure packages are installed'

    describe package('aptitude') do
        it { should be_installed }
    end

    describe package('ncdu') do
        it { should be_installed }
    end

    describe package('htop') do
        it { should be_installed }
    end

    describe package('git') do
        it { should be_installed }
    end
end

control 'docker-packages' do
    impact 1.0
    title 'Validate software package installations'
    desc 'Ensure packages are installed'

    describe package('docker-ce') do
        it { should be_installed }
    end

    describe package('docker-compose') do
        it { should be_installed }
    end
end

control 'vagrant-and-virtualbox-packages' do
    impact 1.0
    title 'Validate software package installations'
    desc 'Ensure packages are installed'

    describe package('virtualbox') do
        it { should be_installed }
    end

    describe package('virtualbox-qt') do
        it { should be_installed }
    end

    describe package('virtualbox-dkms') do
        it { should be_installed }
    end

    describe bash('vboxmanage list systemproperties | grep folder | tr -d "\n"') do
        its('stdout') { should cmp 'Default machine folder:          /home/seb/virtualmachines' }
        its('stdout') { should eq 'Default machine folder:          /home/seb/virtualmachines' }
    end

    describe bash('command') do
    end

    describe package('vagrant') do
        it { should be_installed }
    end
end
