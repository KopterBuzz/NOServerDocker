rm -rf ./rcon
mkdir ./rcon
guit git clone https://github.com/Shockfront-Studios/Nuclear-Option-Server-Tools.git ./rcon
sudo docker build . -t noserver