# Vagrantfile 2020/12/02
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

# Certificates installation:

    config.vm.provision "shell", inline: "sudo dnf reinstall openssl ca-certificates -y", name: "Certificates installation"

# Journal log files configuration:

    config.vm.provision "shell", inline: "sudo cp /etc/systemd/journald.conf journald.bak", name: "backup Journal log files"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=100M/g' /etc/systemd/journald.conf", name: "Journal log SystemMaxUse=100M"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFileSize=/SystemMaxFileSize=100M/g' /etc/systemd/journald.conf", name: "Journal log SystemMaxFileSize=100M"
    config.vm.provision "shell", inline: "sudo sed -i 's/#SystemMaxFiles=/SystemMaxFiles=/g' /etc/systemd/journald.conf", name: "Journal log SystemMaxFiles"

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

    config.vm.provision "shell", inline: "sudo systemctl restart systemd-hostnamed", name: "Restart Network Profiles"
    config.vm.provision "shell", inline: "sudo systemctl restart NetworkManager", name: "Restart NetworkManager"

# TimeDate configuration:

    config.vm.provision "shell", inline: "sudo timedatectl set-timezone Europe/Amsterdam", name: "set-timezone Europe/Amsterdam"
    config.vm.provision "shell", inline: "sudo hwclock -w", name: "sync hwclock"

# Chrony installation:

    config.vm.provision "shell", inline: "sudo dnf install chrony -y", name: "Chrony installation"

# Chrony configuration:

    config.vm.provision "shell", inline: "sudo cp /etc/chrony.conf chrony.bak", name: "backup old Chrony configuration"
    config.vm.provision "shell", inline: "sudo echo '# Customized configuration:' > /etc/chrony.conf", name: "create new Chrony configuration"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# These servers were defined in the Vagrant configuration:' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'server nts1.time.nl iburst nts' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Use public servers from the pool.ntp.org project.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '# Please consider joining the pool (https://www.pool.ntp.org/join.html).' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Use NTP servers from DHCP.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'sourcedir /run/chrony-dhcp' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Record the rate at which the system clock gains/losses time.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#driftfile /var/lib/chrony/drift' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Allow the system clock to be stepped in the first three updates' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '# if its offset is larger than 1 second.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'makestep 1.0 3' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Enable kernel synchronization of the real-time clock (RTC).' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'rtcsync' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Enable hardware timestamping on all interfaces that support it.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#hwtimestamp *' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Increase the minimum number of selectable sources required to adjust' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '# the system clock.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#minsources 2' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Allow NTP client access from local network.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#allow 192.168.0.0/16' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Serve time even if not synchronized to a time source.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'local stratum 8' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Require authentication (nts or key option) for all NTP sources.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#authselectmode require' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Specify file containing keys for NTP authentication.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'keyfile /etc/chrony.keys' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Save NTS keys and cookies.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'ntsdumpdir /var/lib/chrony' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Insert/delete leap seconds by slewing instead of stepping.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#leapsecmode slew' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Get TAI-UTC offset and leap seconds from the system tz database.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'leapsectz right/UTC' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Specify directory for log files.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo 'logdir /var/log/chrony' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

    config.vm.provision "shell", inline: "sudo echo '# Select which information is logged.' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#log measurements statistics tracking' >> /etc/chrony.conf"
    config.vm.provision "shell", inline: "sudo echo '#' >> /etc/chrony.conf"

# Security configuration:

    config.vm.provision "shell", inline: "sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config", name: "modify SELINUX"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=dns"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ssh" # Already enabled
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ntp"
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=ptp"
    config.vm.provision "shell", inline: "sudo firewall-cmd --reload", name: "reload Firewall"

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

# MicroCode installation:

    config.vm.provision "shell", inline: "sudo dnf install iucode-tool -y", name: "Intel MicroCode installation"
    config.vm.provision "shell", inline: "sudo dnf install lm_sensors -y", name: "Sensor MicroCode installation"

# Check Timers (e.g. ssd-trim):

    config.vm.provision "shell", inline: "systemctl list-timers --no-pager --all >> timers.log", name: "Check Timers"

# Main packages installation:

    config.vm.provision "shell", inline: "sudo dnf install htop nano neofetch tree wget -y", name: "Main packages installation"

# Cockpit installation:
    config.vm.provision "shell", inline: "sudo dnf install cockpit cockpit-machines cockpit-pcp cockpit-selinux cockpit-storaged PackageKit virt-viewer -y", name: "Cockpit installation"

# Enable cockpit:
    config.vm.provision "shell", inline: "sudo firewall-cmd --permanent --zone=public --add-service=cockpit", name: "Firewall: enable Cockpit"
    config.vm.provision "shell", inline: "sudo firewall-cmd --reload"
    config.vm.provision "shell", inline: "sudo systemctl enable cockpit.socket"
# systemctl start libvirtd
# systemctl enable libvirtd

# visit cockpit: ip-address:9090

# Flatpak installation:

    config.vm.provision "shell", inline: "sudo dnf install flatpak flatpak-selinux flatpak-session-helper -y", name: "Flatpak installation"
    config.vm.provision "shell", inline: "sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo", name: "Flathub Repo"
    config.vm.provision "shell", inline: "sudo flatpak remotes", name: "Flatpak synchronize"

# sudo flatpak install flathub notepadqq -y # NotepadQQ
# sudo flatpak install flathub wps -y # WPS Office
# sudo flatpak install flathub teams-for-linux -y # Teams

# Development Tools installation:

    config.vm.provision "shell", inline: "sudo dnf groupinstall 'Development Tools' -y", name: "Flatpak synchronize"

# Toolbox installation:

    config.vm.provision "shell", inline: "sudo git clone 'https://github.com/containers/toolbox.git'", name: "Clone Toolbox git"
    config.vm.provision "shell", inline: "sudo dnf install toolbox -y", name: "Toolbox installation"
    config.vm.provision "shell", inline: "toolbox create -c Test -y", name: "Create Toolbox Test"

# Additional Package installation:

    # config.vm.provision "shell", path: node[:addon], name: "Additional Package installation"

# Powerline installation:

    config.vm.provision "shell", inline: "sudo dnf install powerline vim-powerline tmux-powerline powerline-fonts -y", name: "Powerline installation"

    config.vm.provision "shell", inline: "sudo echo '' >> .bashrc"
    config.vm.provision "shell", inline: "sudo echo '# Powerline' >> .bashrc"
    config.vm.provision "shell", inline: "sudo echo 'if [ -f `which powerline-daemon` ]; then' >> .bashrc"
    config.vm.provision "shell", inline: "sudo echo '  powerline-daemon -q' >> .bashrc"
    config.vm.provision "shell", inline: "sudo echo '  POWERLINE_BASH_CONTINUATION=1' >> .bashrc"
    config.vm.provision "shell", inline: "sudo echo '  POWERLINE_BASH_SELECT=1' >> .bashrc"
    config.vm.provision "shell", inline: "sudo echo '  . /usr/share/powerline/bash/powerline.sh' >> .bashrc"
    config.vm.provision "shell", inline: "sudo echo 'fi' >> .bashrc"
    config.vm.provision "shell", inline: "sudo echo '' >> .bashrc"

# Clear Page Cache, dentries and inodes:

    config.vm.provision "shell", inline: "sudo sync; echo 3 > /proc/sys/vm/drop_caches", name: "Clear Caches"

# Clear Bash history:

    config.vm.provision "shell", inline: "history -c", name: "Clear Bash history"

# Cleanup Network Profiles:

#    config.vm.provision "shell", inline: "sudo nmcli con down 'enp0s3'", name: "Disable Vagrant Connection"

# System reboot:

    config.vm.provision "shell", inline: "sudo systemctl reboot", name: "Automatic reboot"

    end
  end
end
