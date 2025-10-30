FROM steamcmd/steamcmd:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Eastern

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install jq -y
RUN apt-get install file -y
RUN apt-get install unzip -y
RUN apt-get install wget -y
RUN steamcmd +force_install_dir /server +login anonymous +app_update 3930080 validate +quit
RUN cp -r /server/linux64/* /server -f
RUN wget -O "BepInEx_linux_x64_5.4.23.3.zip" "https://github.com/BepInEx/BepInEx/releases/download/v5.4.23.3/BepInEx_linux_x64_5.4.23.3.zip"
RUN unzip -o "BepInEx_linux_x64_5.4.23.3.zip" -d "/server"
RUN rm "BepInEx_linux_x64_5.4.23.3.zip"

WORKDIR /server
COPY ./server /server
COPY ./bepinex_preconfig /server

WORKDIR /
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/replays"]
VOLUME ["/missions"]
ENTRYPOINT ["/entrypoint.sh"]