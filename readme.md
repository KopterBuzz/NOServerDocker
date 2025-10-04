# NOServerDocker - Dockerized Nuclear Option Dedicated Server with BepInEx 5 Integration

## How to use:

- clone/download the repo
- install and preconfigure any mods you may need in bepinex_preconfig plugins and config subdirectories

    as an example, this repo includes my Tacview Exporter mod, [NOBlackBox](https://github.com/KopterBuzz/NOBlackBox) by default

- install any missions you may need into the missions directory
- run build.sh, it will download all dependencies and build the docker image locally
- testRun.sh demonstrates how to configure and launch a container with the image
