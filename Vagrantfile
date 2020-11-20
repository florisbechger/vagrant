# Vagrantfile 2020/11/20
# VirtualBox Version 6.1.16
# Vagrant Version 2.2.13

Vagrant.require_version ">= 2.2.13"

# dns servers: 8.8.8.8 8.8.4.4 (Google)

Vagrant.configure("2") do |config|

nodes = [
    { hostname:'test', prilan:'10.0.2.90', prigw:'10.0.2.1', nat:'NatNetwork', cpu:'2', mem:'4096', vram:'16', graphic:'VBoxVGA', acc3d:'off', box:'centos.box', disk:'40GB', addon:'[path\to\test.sh]' },
#    { [another node] },
    ]

  nodes.each do |node|

# Nodes configuration:

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

    config.vm.network "private_network", :adapter=>2, ip:node[:prilan], gateway:node[:prigw], virtualbox__intnet:node[:nat]
    config.vm.network "public_network", :adapter=>3, type: "dhcp"
#    config.vm.network "forwarded_port", guest: 22, host: 22, auto_correct: true

      config.vm.provider:virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--name", node[:hostname]]
        vb.customize ["modifyvm", :id, "--memory", node[:mem]]
        vb.customize ["modifyvm", :id, "--cpus", node[:cpu]]
        vb.customize ["modifyvm", :id, "--vram", node[:vram]]
        vb.customize ["modifyvm", :id, "--accelerate3d", node[:acc3d]]
        vb.customize ["modifyvm", :id, "--graphicscontroller", node[:graphic]]
        vb.customize ["modifyvm", :id, "--description", node[:prilan]]
      end

# TimeDate configuration:

    config.vm.provision "shell", inline: "sudo timedatectl set-timezone Europe/Amsterdam", name: "set-timezone Europe/Amsterdam"
    config.vm.provision "shell", inline: "sudo hwclock -w", name: "sync hwclock"

# Security configuration:

    config.vm.provision "shell", inline: "sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config", name: "modify SELINUX=permissive"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=dns", name: "modify Firewall DNS"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ssh", name: "modify Firewall SSH" # Already enabled
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ntp", name: "modify Firewall NTP"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ptp", name: "modify Firewall PTP"
    config.vm.provision "shell", inline: "sudo firewall-cmd --reload", name: "reload Firewall"

# Modify Network configurations:

#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s3' ipv4.addresses 10.0.2.91/24"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s3' ipv4.gateway 10.0.2.1"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s3' ipv4.dns '8.8.8.8 8.8.4.4'"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s3' connection.autoconnect yes"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s3' ipv6.method ignore"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s3' ipv4.method manual"

    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ipv4.dns '8.8.8.8 8.8.4.4'"
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' connection.autoconnect yes"
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ipv6.method ignore"

# Cleanup Network Profiles:

    config.vm.provision "shell", inline: "sudo systemctl restart systemd-hostnamed", name: "Restart Network Profiles"
    config.vm.provision "shell", inline: "sudo systemctl restart NetworkManager", name: "Restart NetworkManager"

# Journal log files configuration:

    config.vm.provision "shell", inline: "sudo cp /etc/systemd/journald.conf journald.bak", name: "backup Journal log files"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=100M/g' /etc/systemd/journald.conf", name: "Journal log SystemMaxUse=100M"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFileSize=/SystemMaxFileSize=100M/g' /etc/systemd/journald.conf", name: "Journal log SystemMaxFileSize=100M"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFiles=/SystemMaxFiles=/g' /etc/systemd/journald.conf", name: "Journal log SystemMaxFiles"

# SSH configuration:

    config.vm.provision "shell", inline: "sudo cp /etc/ssh/sshd_config sshd_config.bak", name: "backup SSH configuration"
    config.vm.provision "shell", inline: "sudo systemctl restart sshd.service", name: "restart SSH service"
    config.vm.provision "shell", inline: "sudo systemctl enable sshd.service", name: "enable SSH service"
#    config.vm.provision "shell", inline: "sudo echo 'UseDNS no' >> /etc/ssh/sshd_config", name: "SSH service: UseDNS no"

# Update system:

    config.vm.provision "shell", inline: "sudo dnf clean all -y", name: "clean the DNF package repositorycaches"
    config.vm.provision "shell", inline: "sudo dnf makecache -y", name: "update the DNF package repository cache"
    config.vm.provision "shell", inline: "sudo dnf autoremove -y", name: "remove unnecessary packages if available"
    config.vm.provision "shell", inline: "sudo dnf upgrade-minimal -y", name: "only install absolutely required security patches"
#    config.vm.provision "shell", inline: "sudo dnf upgrade --sec-severity Critical --best -y", name: "upgrade security patches"
#    config.vm.provision "shell", inline: "sudo dnf upgrade -y", name: "full system update"

# Main packages installation:

    config.vm.provision "shell", inline: "sudo dnf install nano tree wget -y", name: "Main packages installation"

# Additional Package installation:

    # config.vm.provision "shell", path: node[:addon], name: "Additional Package installation"

# Clear Page Cache, dentries and inodes:

    config.vm.provision "shell", inline: "sudo sync; echo 3 > /proc/sys/vm/drop_caches", name: "Clear Caches"

# Clear Bash history:

    config.vm.provision "shell", inline: "history -c", name: "Clear Bash history"

# System reboot:

    config.vm.provision "shell", inline: "sudo systemctl reboot", name: "Automatic reboot"

    end
  end
end
