# Setup Vagrant environment to host virtual nodes in Windows command prompt

cls
REM Windows commands:

# Make main directory for Vagrant and change to this directory, change [username] to your own username:
md C:\Users\[username]\Documents\Vagrant
cd C:\Users\[username]\Documents\Vagrant

# List your Vagrant images:
vagrant box list

# Create a virtual node in VirtualBox and make sure all files go into this directory
# Create an image of your freshly installed instance, e.g.:

vagrant package --base centos --output centos.box

# Register this image to Vagrant, so it knows where to pull the image from:
vagrant box add centos.box file:///C:\Users\[username]\Documents\Vagrant\centos.box

# Now you can provision your VirtualBox with new nodes:
vagrant up # build a complete new node
vagrant up --no-provision # build your new node without provisioning
vagrant reload --provision # only provision the allready created nodes

# Some commands:
REM VBoxManage startvm <machine> --type headless # start node without GUI
REM vagrant reload <machine> # restart node
REM vagrant halt <machine> # stop node
REM vagrant destroy <machine> -f # delete node
REM VBoxManage unregistervm <machine> --delete # unregister you node
REM vagrant global-status --prune # delete obsolete nodes

# Other commands:
REM vagrant box remove centos.box # Unregister the image from Vagrant
REM del centos.box # Delete the image entirely