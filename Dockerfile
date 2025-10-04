FROM steamcmd/steamcmd:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Eastern

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install jq -y

WORKDIR /server
COPY ./server /server

WORKDIR /
COPY ./missions /missions
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]