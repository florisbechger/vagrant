
# Vagrantfile 2020/12/05
# VirtualBox Version 6.1.18
# Vagrant Version 2.2.14
# Centos 8 Stream LVM

Vagrant.require_version ">= 2.2.14"

# VM configuration, add more nodes if necessary:

Vagrant.configure("2") do |config|

nodes = [
    { hostname:'test.local', baselan:'10.0.0.90', seclan:'10.0.0.92', netmask:'255.255.255.0', nictype:'virtio', gw:'10.0.0.1', int:'intnet', cpu:'2', mem:'4096', vram:'16', graphic:'VBoxVGA', acc3d:'off', box:'centos.box', disk:'30GB', addon:'[path\to\test.sh]'},
#    { [another node] },
    ]

  nodes.each do |node|

# Nodes configuration:
    config.vagrant.host = "linux"
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
    config.vm.network "forwarded_port", guest: 22, host: 2222, auto_correct: true
    config.ssh.forward_agent = "true"
    config.vm.usable_port_range = 2200..2250 # 8199..8999

# NIC 1 configuration (public/vagrant):
#    config.vm.base_address = node[:baselan]

# NIC 2 configuration (private):
    config.vm.network "private_network", :adapter=>2, ip:node[:seclan], netmask:node[:netmask], gateway:node[:gw], nic_type:node[:nictype], virtualbox__intnet:node[:int], bridge: "wlp0s20f36 enp0s31f"

# Main customisation:
      config.vm.provider:virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--name", node[:hostname]]
        vb.customize ["modifyvm", :id, "--memory", node[:mem]]
        vb.customize ["modifyvm", :id, "--cpus", node[:cpu]]
        vb.customize ["modifyvm", :id, "--vram", node[:vram]]
        vb.customize ["modifyvm", :id, "--accelerate3d", node[:acc3d]]
        vb.customize ["modifyvm", :id, "--graphicscontroller", node[:graphic]]
        vb.customize ["modifyvm", :id, "--description", node[:prilan]]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end

# Hosts configuration:
    config.vm.provision "shell", inline: "echo '10.0.0.90	test.local	test' >> /etc/hosts"
    config.vm.provision "shell", inline: "echo '10.0.0.93	test.local	test' >> /etc/hosts"

# TimeDate configuration:
    config.vm.provision "shell", inline: "sudo timedatectl set-timezone Europe/Amsterdam"
    config.vm.provision "shell", inline: "sudo hwclock -w"

# Security configuration:
    config.vm.provision "shell", inline: "sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config"

# Journal configuration:
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=100M/g' /etc/systemd/journald.conf"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFileSize=/SystemMaxFileSize=100M/g' /etc/systemd/journald.conf"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFiles=/SystemMaxFiles=/g' /etc/systemd/journald.conf"

# Network modify configuration:
    config.vm.provision "shell", inline: "sudo nmcli connection show --active" # Show active connections
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ifname [own name] con-name [own name]" # Do not rename
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ipv4.method manual" # Already preconfigured
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ipv6.method ignore" # Already preconfigured
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ipv4.addresses 10.0.0.90/24" # Already configured
#    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ipv4.gateway '10.0.0.1'" # Already configured
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' ipv4.dns '192.168.0.1 10.0.0.1 8.8.8.8 8.8.4.4'"
    config.vm.provision "shell", inline: "sudo nmcli connection modify 'System enp0s8' connection.autoconnect yes"

# Restart Network Profiles:
    config.vm.provision "shell", inline: "sudo systemctl restart systemd-hostnamed"
    config.vm.provision "shell", inline: "sudo systemctl restart NetworkManager"

# Firewall configuration:
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=dns"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ssh" # already enabled
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ntp"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ptp"
    config.vm.provision "shell", inline: "sudo firewall-cmd --reload"

# SSH configuration:
#    config.vm.provision "shell", inline: "sudo echo 'UseDNS no' >> /etc/ssh/sshd_config"
    config.vm.provision "shell", inline: "sudo systemctl restart sshd.service"
    config.vm.provision "shell", inline: "sudo systemctl enable sshd.service"

# Update system:
    config.vm.provision "shell", inline: "sudo dnf clean all -y", name: "clean the DNF package repositorycaches"
    config.vm.provision "shell", inline: "sudo dnf makecache -y", name: "update the DNF package repository cache"
    config.vm.provision "shell", inline: "sudo dnf autoremove -y", name: "remove unnecessary packages if available"
    config.vm.provision "shell", inline: "sudo dnf upgrade --sec-severity Critical --best -y", name: "upgrade security patches"
#    config.vm.provision "shell", inline: "sudo dnf upgrade-minimal -y", name: "only newest patches to possibly resolve an issue"

# Clear Page Cache, dentries and inodes:
    config.vm.provision "shell", inline: "sudo sync; echo 3 > /proc/sys/vm/drop_caches"

# Clear Bash history:
    config.vm.provision "shell", inline: "history -c"

# Check Timers (e.g. ssd-trim):
    config.vm.provision "shell", inline: "systemctl list-timers --no-pager --all >> timers.log"

# Certificates re-installation:
#    config.vm.provision "shell", inline: "sudo dnf reinstall openssl ca-certificates -y"

# Additional Package installation:
#    config.vm.provision "shell", path: node[:addon]

# DNF History:
#    config.vm.provision "shell", inline: "sudo dnf history >> dnf.log"

# Disable Public/Vagrant Connection:
#    config.vm.provision "shell", inline: "sudo nmcli connection down 'enp0s3'"

# System reboot:
    config.vm.provision "shell", inline: "sudo systemctl reboot", name: "Automatic reboot"

    end
  end
end
