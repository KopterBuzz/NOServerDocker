PWD=$(pwd)
SERVERDIR="${PWD}/server"
rm -r ${SERVERDIR} -f
mkdir ${SERVERDIR}

sudo add-apt-repository -y multiverse 
sudo apt update
echo steam steam/question select "I AGREE" | sudo debconf-set-selections
sudo apt install steamcmd unzip
echo ${SERVERDIR}
steamcmd +force_install_dir ${SERVERDIR} +login anonymous +app_update 3930080 validate +quit

cp -r ${SERVERDIR}/linux64/* ${SERVERDIR} -f

wget -O "./bepinex/BepInEx_linux_x64_5.4.23.3.zip" "https://github.com/BepInEx/BepInEx/releases/download/v5.4.23.3/BepInEx_linux_x64_5.4.23.3.zip"
unzip -o "./bepinex/BepInEx_linux_x64_5.4.23.3.zip" -d "./bepinex/"
rm "./bepinex/BepInEx_linux_x64_5.4.23.3.zip"

cp -a "./bepinex/." ${SERVERDIR} -f
cp -a "./bepinex_preconfig/." ${SERVERDIR} -f