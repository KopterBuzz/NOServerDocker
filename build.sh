rm -rf ./rcon
mkdir ./rcon
git clone https://github.com/Shockfront-Studios/Nuclear-Option-Server-Tools.git ./rcon
sed -i -e 's/5000/50000/g' ./rcon/ServerControlPanel/config.py
sudo docker build . -t noserver