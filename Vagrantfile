def gui?
  !ENV.fetch('GUI', '').empty?
end

VAGRANT_COMMAND = ARGV[0]

Vagrant.configure("2") do |config|

    # global vars
    timezone = "Asia/Manila"
    project = File.basename(__dir__)

    if VAGRANT_COMMAND == "ssh"
        config.ssh.username = "chu"
    end

    # vmware
    config.vm.provider "vmware_desktop" do |v|
        v.ssh_info_public = true
        v.allowlist_verified = true
    end

    # https://github.com/devopsgroup-io/vagrant-hostmanager
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = true
    config.hostmanager.include_offline = true

    config.vm.provision :shell, inline: 'echo $(hostname) is up'

    # alpine
    config.vm.define "alpine" do |h|
        h.vm.box = "freepaddler/alpine"
        h.vm.hostname = "#{project}-alpine"
        h.vm.provider "vmware_desktop" do |v|
            v.memory = 512
            v.cpus = 2
            v.gui = gui?
        end
        h.vm.synced_folder ".", "/vagrant", disabled: "true"
        h.vm.provision "timezone", type: "shell", run: "once",
            inline: "setup-timezone #{timezone}"
    end

    # centos
    config.vm.define "centos" do |h|
        h.vm.box = "freepaddler/centos9"
        h.vm.hostname = "#{project}-centos"
        h.vm.provider "vmware_desktop" do |v|
            v.memory = 512
            v.cpus = 2
        end
        h.vm.synced_folder ".", "/vagrant", disabled: "true"
        h.vm.provision "timezone", type: "shell", run: "once",
            inline: "timedatectl set-timezone #{timezone}"
    end

    config.vm.define "debian" do |h|
        h.vm.box = "freepaddler/debian"
        h.vm.hostname = "#{project}-debian"
        h.vm.provider "vmware_desktop" do |v|
            v.memory = 512
            v.cpus = 2
        end
        h.vm.synced_folder ".", "/vagrant", disabled: "true"
        h.vm.provision "timezone", type: "shell", run: "once",
            inline: "timedatectl set-timezone #{timezone}"
    end

    config.vm.define "freebsd" do |h|
        h.vm.box = "freepaddler/freebsd"
        h.vm.hostname = "#{project}-freebsd"
        h.vm.provider "vmware_desktop" do |v|
            v.memory = 512
            v.cpus = 2
        end
        # define, but disable to avoid warnings
        h.vm.synced_folder ".", "/vagrant", disabled: "true"
        h.vm.provision "timezone", type: "shell", run: "once",
            inline: <<-SHELL
                cp "/usr/share/zoneinfo/#{timezone}" /etc/localtime
                sysrc timezone="#{timezone}"
            SHELL
    end
end