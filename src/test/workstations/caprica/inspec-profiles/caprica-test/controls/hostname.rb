title "audit hostname"

control "hostname" do
    impact 1.0
    title "Check the hostname"
    desc "Ensure that the hostname is set correctly"

    describe sys_info do
        its('hostname') { should cmp 'caprica-test' }
    end
end
