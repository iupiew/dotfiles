### some useful commands

# set default shell to fish
chsh -s $(which fish)

# set default shell to bash

chsh -s $(which bash)

# log dir sizes
du -h -a --max-depth=0 * | sort -hr

# ip 
wget -qO- ifconfig.me/ip
# internal ip
ip addr | grep inet
