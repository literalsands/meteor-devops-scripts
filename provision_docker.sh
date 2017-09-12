curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
# app-cache policy docker-ce # Use this to make sure we're installing docker fromt he right repository.
apt-get install -y docker-ce
systemctl status docker

