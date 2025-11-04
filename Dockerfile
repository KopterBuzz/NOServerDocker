FROM steamcmd/steamcmd:latest
EXPOSE 5000
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Eastern

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install jq -y
RUN apt-get install file -y
RUN apt-get install unzip -y
RUN apt-get install wget -y
RUN apt-get install python3 -y
RUN apt-get install python3-venv -y
RUN steamcmd +force_install_dir /server +login anonymous +app_update 3930080 validate +quit
RUN cp -r /server/linux64/* /server -f
RUN wget -O "BepInEx_linux_x64_5.4.23.3.zip" "https://github.com/BepInEx/BepInEx/releases/download/v5.4.23.3/BepInEx_linux_x64_5.4.23.3.zip"
RUN unzip -o "BepInEx_linux_x64_5.4.23.3.zip" -d "/server"
RUN rm "BepInEx_linux_x64_5.4.23.3.zip"
WORKDIR /server
COPY ./server /server
COPY ./bepinex_preconfig /server


WORKDIR /rcon
COPY ./rcon /rcon
WORKDIR /rcon/ServerControlPanel
RUN chmod +x install.sh
RUN python3 -m venv venv
RUN source venv/bin/activate
RUN pip install -r requirements.txt

WORKDIR /
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
VOLUME ["/replays"]
VOLUME ["/missions"]
ENTRYPOINT ["/entrypoint.sh"]