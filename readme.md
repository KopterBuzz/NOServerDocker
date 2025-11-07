# NOServerDocker - Dockerized Nuclear Option Dedicated Server with BepInEx 5 Integration

This project provides resources to build ta Docker Image that is preconfigured to run a Nuclear Option Dedicated Server with the Official [ServerControlPanel](https://github.com/Shockfront-Studios/Nuclear-Option-Server-Tools/tree/main/ServerControlPanel) for remote control. It also includes a preconfigured BepInEx 5 Framework with the NOBlackBox Tacview Exporter Plugin.

## Usage Instructions:

### Disclaimer:

    This guide assumes that you read and understood the official documentation for Nuclear Option Dedicated Server Tools.

Official Documentation: [https://github.com/Shockfront-Studios/Nuclear-Option-Server-Tools](https://github.com/Shockfront-Studios/Nuclear-Option-Server-Tools)

- clone/download the repo
- install and preconfigure any mods you may need in bepinex_preconfig plugins and config subdirectories

    as an example, this repo includes our Tacview Exporter mod, [NOBlackBox](https://github.com/KopterBuzz/NOBlackBox) by default

- install any missions you may need into the missions directory

    if you leave the folder empty, the server will just default to rotating Escalation and Terminal Control

- run build.sh, it will download all dependencies and build the docker image locally
- the docker image's entrypoint script is configurable via several command line arguments.
- to get a practical understanding of how the command line arguments function, 3 example launch scripts are provided:
  - provided example [testRun.sh](https://github.com/KopterBuzz/NOServerDocker/blob/main/testRun.sh) demonstrates how to configure and launch a single container with the image
  - provided example [stressTest.sh](https://github.com/KopterBuzz/NOServerDocker/blob/main/stressTest.sh) runs 4x instances with a [large mission](https://steamcommunity.com/sharedfiles/filedetails/?id=3598693787) and puts your cpu to the test.
  - provided example [runDogfight.sh](https://github.com/KopterBuzz/NOServerDocker/blob/main/runDogfight.sh) will spawn a 4 instances of the dedicated server, however
- when you create your own custom launch profile, please do take care of configuring the command line arguments properly
pay special attention to:
```
--password
--rconPassword
--portValue
--queryValue
--rconPort
--internalRconPort
```
- DO NOT run your server with default rcon password found in the repo. Everyone can read it here.
- The server has an internal rcon port (tcp) that only listens on localhost. This is by default configured to 7779. This project currently uses this default 7779 port for every instance. Keep this in mind if you configure running multiple servers, do not try to bind 7779 for server or query port, unless you also change the internal rcon port. In case you DO decide to change the internal rcon port from 7779 to something different, you will also need to change it in the [ServerControlPanel's](https://github.com/Shockfront-Studios/Nuclear-Option-Server-Tools/tree/main/ServerControlPanel) settings. This project achieves configuring ServerControlPanel inside the container's [entrypoint script](https://github.com/KopterBuzz/NOServerDocker/blob/main/entrypoint.sh#L144) and they are configurable via command line arguments:
```
--rconPort
--internalRconPort
--rconPassword
```
## Notes:
the Dockerfile uses 4 volumes:
```
VOLUME ["/replays"]
VOLUME ["/missions"]
VOLUME ["/banlist"]
VOLUME ["/serverlog"]
```
Their purpose follows their name:

- /replays is for Tacview exports.

- /missions is the mission directory where you need to dump all your mission files.

  - If you get them from steam workshop, DO TAKE CARE to rename the the mission folder from workshop content id to the mission's name, it needs to be the exact same file name as the mission's json file.

- /banlist is where the banlist file used by the server will live.

- /serverlog is where the containers will dump their dedicated server logs.

# TODO
- better password management
- automated scaling
# Contributing
- feedback, suggestions, issue reports are welcome
- if you wish to contribute to the repository, fork the project and open a Pull Request against [the dev branch](https://github.com/KopterBuzz/NOServerDocker/tree/dev)