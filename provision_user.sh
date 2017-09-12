# Create user with home directory, groups, and Bash shell.
id -u $1 &>/dev/null || useradd $1 -G sudo,dip,lxd -d /home/$1 -s /bin/bash
usermod -aG $1 docker node

# Give the user the same keys as root.
cp -R $HOME/.ssh /home/$1/
chown -R $1 /home/$1
