# Vagrantfile 2020/12/05
# VirtualBox Version 6.1.16
# Vagrant Version 2.2.14

Vagrant.require_version ">= 2.2.14"

Vagrant.configure("2") do |config|

nodes = [
    { hostname:'test', prilan:'10.0.2.90', seclan:'10.0.2.91', gw:'10.0.2.1', int:'intnet', cpu:'2', mem:'4096', vram:'16', graphic:'VBoxVGA', acc3d:'off', box:'centos.box', disk:'40GB', addon:'[path\to\test.sh]', dns: '89.101.251.228 89.101.251.229'},
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

    config.disksize.size = node[:disk]

    config.vm.base_address = node[:prilan]
    config.vm.network "private_network", :adapter=>2, ip:node[:prilan], gateway:node[:gw], virtualbox__intnet:node[:int]
    config.vm.network "private_network", :adapter=>3, ip:node[:seclan], gateway:node[:gw], virtualbox__intnet:node[:int]

    config.vm.network "forwarded_port", guest: 22, host: 2222, auto_correct: true
    config.ssh.forward_agent = "true"
    config.vm.usable_port_range = 2200..2250 # 8199..8999

      config.vm.provider:virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--name", node[:hostname]]
        vb.customize ["modifyvm", :id, "--memory", node[:mem]]
        vb.customize ["modifyvm", :id, "--cpus", node[:cpu]]
        vb.customize ["modifyvm", :id, "--vram", node[:vram]]
        vb.customize ["modifyvm", :id, "--accelerate3d", node[:acc3d]]
        vb.customize ["modifyvm", :id, "--graphicscontroller", node[:graphic]]
        vb.customize ["modifyvm", :id, "--description", node[:prilan]]
      end

# Journal log files configuration:

    config.vm.provision "shell", inline: "sudo cp /etc/systemd/journald.conf journald.bak"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=100M/g' /etc/systemd/journald.conf"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFileSize=/SystemMaxFileSize=100M/g' /etc/systemd/journald.conf"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFiles=/SystemMaxFiles=/g' /etc/systemd/journald.conf"

# Security configuration:

    config.vm.provision "shell", inline: "sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config"

# Firewall configuration:

    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=dns"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ssh" # Already enabled
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ntp"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ptp"
    config.vm.provision "shell", inline: "sudo firewall-cmd --reload"

# SSH configuration:

    config.vm.provision "shell", inline: "sudo cp /etc/ssh/sshd_config sshd_config.bak"
    config.vm.provision "shell", inline: "sudo systemctl restart sshd.service"
    config.vm.provision "shell", inline: "sudo systemctl enable sshd.service"
#    config.vm.provision "shell", inline: "sudo echo 'UseDNS no' >> /etc/ssh/sshd_config"

# Modify Network configurations:

    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ifname enp0s8 con-name enp0s8"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' ipv4.addresses 10.0.2.90/24" # already configured
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' ipv4.dns '8.8.8.8 8.8.4.4'"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' connection.autoconnect yes"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' ipv6.method ignore"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' ipv4.gateway '10.0.2.1'"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' ipv4.method manual"

    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s9' ifname enp0s9 con-name enp0s9"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s8' ipv4.addresses 10.0.2.91/24" # already configured
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s9' ipv4.dns '8.8.8.8 8.8.4.4'"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s9' connection.autoconnect yes"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s9' ipv6.method ignore"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s9' ipv4.gateway '10.0.2.1'"
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'enp0s9' ipv4.method manual"

# Restart Network Profiles:

    config.vm.provision "shell", inline: "sudo systemctl restart systemd-hostnamed"
    config.vm.provision "shell", inline: "sudo systemctl restart NetworkManager"

# TimeDate configuration:

    config.vm.provision "shell", inline: "sudo timedatectl set-timezone Europe/Amsterdam"
    config.vm.provision "shell", inline: "sudo hwclock -w"

# Update system:

    config.vm.provision "shell", inline: "sudo dnf clean all -y", name: "clean the DNF package repositorycaches"
    config.vm.provision "shell", inline: "sudo dnf makecache -y", name: "update the DNF package repository cache"
    config.vm.provision "shell", inline: "sudo dnf autoremove -y", name: "remove unnecessary packages if available"
    config.vm.provision "shell", inline: "sudo dnf upgrade-minimal -y", name: "only install absolutely required security patches"
#    config.vm.provision "shell", inline: "sudo dnf upgrade --sec-severity Critical --best -y", name: "upgrade security patches"
#    config.vm.provision "shell", inline: "sudo dnf upgrade -y", name: "full system update"

# Clear Page Cache, dentries and inodes:

    config.vm.provision "shell", inline: "sudo sync; echo 3 > /proc/sys/vm/drop_caches"

# Clear Bash history:

    config.vm.provision "shell", inline: "history -c"

# Cleanup Network Profiles:

# sudo nmcli con down 'enp0s3' # Disable Vagrant Connection
    config.vm.provision "shell", inline: "sudo nmcli con del 'Wired connection 1'" # Delete Wired connection 1
    config.vm.provision "shell", inline: "sudo nmcli con del 'Wired connection 2'" # Delete Wired connection 2

# Check Timers (e.g. ssd-trim):

    config.vm.provision "shell", inline: "systemctl list-timers --no-pager --all >> timers.log"

# Certificates re-installation:

#    config.vm.provision "shell", inline: "sudo dnf reinstall openssl ca-certificates -y"

# Additional Package installation:

#    config.vm.provision "shell", path: node[:addon]

# DNF History:

    config.vm.provision "shell", inline: "sudo dnf history >> dnf.log"

# System reboot:

    config.vm.provision "shell", inline: "sudo systemctl reboot", name: "Automatic reboot"

    end
  end
end
