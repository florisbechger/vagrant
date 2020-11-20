# Place in your Vagrant folder

Vagrant.require_version ">= 2.2.9"

# dns servers,e.g.: 8.8.8.8 8.8.4.4 (Google)

Vagrant.configure("2") do |config|

nodes = [
    { hostname:'toaster', publan:'192.168.0.90', pubgw:'192.168.0.1', prilan:'10.0.2.90', prigw:'10.0.2.1', nat:'NatNetwork', cpu:'2', mem:'4096', vram:'16', graphic:'VBoxVGA', acc3d:'off', box:'centos.box', disk:'32GB', addon:'' },
#    { [another node] },
    ]

  nodes.each do |node|

#	Nodes configuration:

    config.vagrant.host = "windows"
    config.vm.provider "virtualbox"

    config.vm.ignore_box_vagrantfile = true
    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.ssh.username = "root"
    config.ssh.password = "password"
    config.ssh.forward_agent = "false"
    config.ssh.forward_x11 = "false"
    config.ssh.shell = "bash"

    config.vm.define node[:hostname] do |config|
    config.vm.box = node[:box]
    config.vm.hostname = node[:hostname]
    config.vm.base_address = node[:prilan]

#    config.vm.disk :disk, name: node[:hostname] # , disk_ext: "vdi"
#    config.vm.disk :disk, name = node[:hostname]
#    config.disksize.size = node[:disk]

    config.vm.network "private_network", :adapter=>2, ip:node[:prilan], gateway:node[:prigw] #, virtualbox__intnet:node[:nat]
    config.vm.network "public_network", :adapter=>3, ip:node[:publan], gateway:node[:pubgw] #, virtualbox__intnet:node[:nat]
    config.vm.network "forwarded_port", guest: 22, host: 22, auto_correct: true

      config.vm.provider:virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--name", node[:hostname]]
        vb.customize ["modifyvm", :id, "--memory", node[:mem]]
        vb.customize ["modifyvm", :id, "--cpus", node[:cpu]]
        vb.customize ["modifyvm", :id, "--vram", node[:vram]]
        vb.customize ["modifyvm", :id, "--accelerate3d", node[:acc3d]]
        vb.customize ["modifyvm", :id, "--graphicscontroller", node[:graphic]]
        vb.customize ["modifyvm", :id, "--description", node[:prilan]]
      end

#	TimeDate configuration:

    config.vm.provision "shell", inline: "sudo timedatectl set-timezone Europe/Amsterdam"
    config.vm.provision "shell", inline: "sudo hwclock -w"

#	Security configuration:

    config.vm.provision "shell", inline: "sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=dns"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ssh" # Already enabled
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ntp"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ptp"
    config.vm.provision "shell", inline: "sudo firewall-cmd --reload"

#	Modify Network configurations:

    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ifname enp0s8 con-name enp0s8"
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s9' ifname enp0s9 con-name enp0s9"

    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' ipv4.dns '8.8.8.8 8.8.4.4'"
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s9' ipv4.dns '8.8.8.8 8.8.4.4'"

    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' connection.autoconnect yes"
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' ipv6.method ignore"
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s9' connection.autoconnect yes"
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s9' ipv6.method ignore"

#   Cleanup Network Profiles:

    config.vm.provision "shell", inline: "sudo systemctl restart systemd-hostnamed"
    config.vm.provision "shell", inline: "sudo systemctl restart NetworkManager"

#	Journal log files configuration:

    config.vm.provision "shell", inline: "sudo cp /etc/systemd/journald.conf journald.bak"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=100M/g' /etc/systemd/journald.conf"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFileSize=/SystemMaxFileSize=100M/g' /etc/systemd/journald.conf"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFiles=/SystemMaxFiles=/g' /etc/systemd/journald.conf"

#	SSH configuration:

    config.vm.provision "shell", inline: "sudo cp /etc/ssh/sshd_config sshd_config.bak"
    config.vm.provision "shell", inline: "sudo systemctl restart sshd.service"
    config.vm.provision "shell", inline: "sudo systemctl enable sshd.service"
#    config.vm.provision "shell", inline: "sudo echo 'UseDNS no' >> /etc/ssh/sshd_config"

#   Update system:

    config.vm.provision "shell", inline: "sudo dnf clean all -y" # clean the DNF package repositorycaches
    config.vm.provision "shell", inline: "sudo dnf makecache -y" # update the DNF package repository cache
    config.vm.provision "shell", inline: "sudo dnf autoremove -y" # remove unnecessary packages if available
    config.vm.provision "shell", inline: "sudo dnf upgrade-minimal -y" # only install absolutely required security patches
#    config.vm.provision "shell", inline: "sudo dnf upgrade --sec-severity Critical --best -y" # upgrade security patches
#    config.vm.provision "shell", inline: "sudo dnf upgrade -y" # full system update

#	Chrony configuration:

    config.vm.provision "shell", inline: "sudo dnf install chrony --best -y"

    config.vm.provision "shell", inline: "sudo cp /etc/chrony.conf chrony.bak"
    config.vm.provision "shell", inline: "sudo echo '# Customized configuration:' > /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# allow 192.168.0.0/16' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '# driftfile /var/lib/chrony/drift' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# ntsdumpdir /var/lib/chrony' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '# server time.cloudflare.com iburst nts' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '# server nts.sth1.ntp.se iburst nts' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '# server nts.sth2.ntp.se iburst nts' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo 'pool nl.pool.ntp.org iburst' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '0.nl.pool.ntp.org iburst' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '1.nl.pool.ntp.org iburst' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '2.nl.pool.ntp.org iburst' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '3.nl.pool.ntp.org iburst' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo 'makestep 1.0 3' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'rtcsync' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'local stratum 8' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'keyfile /etc/chrony.keys' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'leapsectz right/UTC' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'logdir /var/log/chrony' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo systemctl restart chronyd"
    config.vm.provision "shell", inline: "sudo systemctl enable chronyd"

#	Main packages installation:

    config.vm.provision "shell", inline: "sudo dnf install nano tree wget --best -y"

#	Additional Package installation:

    # config.vm.provision "shell", path: node[:addon]

#   Clear Page Cache, dentries and inodes:

    config.vm.provision "shell", inline: "sudo sync; echo 3 > /proc/sys/vm/drop_caches"

#   Clear Bash history:

    config.vm.provision "shell", inline: "history -c"

#   System reboot:

#    config.vm.provision "shell", inline: "sudo systemctl reboot", name: "Automatic reboot"

    end
  end
end
