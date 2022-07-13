title "audit files and folders"

control "filesystem" do
    impact 1.0
    title "Validate filesystem setup (files and folders)"
    desc "Ensure all mandatory files and folders are created at their respective default location (ensure a common filesystem layout)"

    describe file("/home/seb/repos") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/seb/tmp") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/home/seb/virtualmachines") do
        it { should exist }
        it { should_not be_file }
        it { should be_directory }
    end

    describe file("/etc/motd") do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
    end

    describe file("/home/seb/.gitconfig") do
        it { should exist }
        it { should be_file }
        it { should_not be_directory }
    end
end
