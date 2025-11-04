#!/usr/bin/env bash
# Usage:
# ./generate_server_config.sh \
#   --modded true \
#   --name "My Server" \
#   --port-override true --port-value 7777 \
#   --query-override true --query-value 7778 \
#   --password "secret" \
#   --maxplayers 8 \
#   --nostoptime 30.0 \
#   --output ./server_config.json \
#   --rconPort 7779

set -e

# Default values
MODDED=false
SERVER_NAME="Default Server Name"
PORT_OVERRIDE=false
PORT_VALUE=7777
QUERY_OVERRIDE=false
QUERY_VALUE=7778
PASSWORD=""
MAX_PLAYERS=8
NO_PLAYER_STOP_TIME=30.0
OUTPUT_FILE="./server/DedicatedServerConfig.json"
RCON_PORT="7779"

MISSIONS_DIR="/missions"

# Parse args
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --modded) MODDED="$2"; shift ;;
        --name) SERVER_NAME="$2"; shift ;;
        --port-override) PORT_OVERRIDE="$2"; shift ;;
        --port-value) PORT_VALUE="$2"; shift ;;
        --query-override) QUERY_OVERRIDE="$2"; shift ;;
        --query-value) QUERY_VALUE="$2"; shift ;;
        --password) PASSWORD="$2"; shift ;;
        --maxplayers) MAX_PLAYERS="$2"; shift ;;
        --nostoptime) NO_PLAYER_STOP_TIME="$2"; shift ;;
        --output) OUTPUT_FILE="$2"; shift ;;
        --rconPort) RCON_PORT="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done


SERVER_LOG_PATH="server/server.log"
# --------------------------------------------------------------------
# Generate MissionRotation JSON array
# --------------------------------------------------------------------
MISSION_ROTATION_JSON=""

if [[ -d "$MISSIONS_DIR" && $(find "$MISSIONS_DIR" -mindepth 1 -type d | wc -l) -gt 0 ]]; then
    # Enumerate subdirectories in ./missions
    echo "Found custom missions in $MISSIONS_DIR — generating MissionRotation..."
    MISSION_ROTATION_JSON=$(find "$MISSIONS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | jq -R -s '
        split("\n") | map(select(length > 0)) |
        map({
            "Key": {
                "Group": "User",
                "Name": . 
            },
            "MaxTime": 7200.0
        })
    ')
else
    # Default mission rotation
    echo "No user missions found — using default built-in MissionRotation."
    MISSION_ROTATION_JSON='[
        {
            "Key": {
                "Group": "BuiltIn",
                "Name": "Escalation"
            },
            "MaxTime": 7200.0
        },
        {
            "Key": {
                "Group": "BuiltIn",
                "Name": "Terminal Control"
            },
            "MaxTime": 7200.0
        }
    ]'
fi

# --------------------------------------------------------------------
# Create JSON using jq
# --------------------------------------------------------------------
jq -n \
  --arg missionsDir "$MISSIONS_DIR" \
  --argjson modded "$MODDED" \
  --arg name "$SERVER_NAME" \
  --argjson portOverride "$PORT_OVERRIDE" \
  --argjson portValue "$PORT_VALUE" \
  --argjson queryOverride "$QUERY_OVERRIDE" \
  --argjson queryValue "$QUERY_VALUE" \
  --arg password "$PASSWORD" \
  --argjson maxPlayers "$MAX_PLAYERS" \
  --argjson noStopTime "$NO_PLAYER_STOP_TIME" \
  --argjson missionRotation "$MISSION_ROTATION_JSON" \
'{
  "MissionDirectory": $missionsDir,
  "ModdedServer": $modded,
  "ServerName": $name,
  "Port": {
    "IsOverride": $portOverride,
    "Value": $portValue
  },
  "QueryPort": {
    "IsOverride": $queryOverride,
    "Value": $queryValue
  },
  "Password": $password,
  "MaxPlayers": $maxPlayers,
  "NoPlayerStopTime": $noStopTime,
  "RotationType": 0,
  "MissionRotation": $missionRotation
}' > "$OUTPUT_FILE"

echo "JSON configuration saved to: $OUTPUT_FILE"
cat ./server/DedicatedServerConfig.json

chmod +x ./rcon/ServerControlPanel/run.sh
cd ./rcon/ServerControlPanel
python3 app.py &

cd ../../server
echo "missions folder content: "
echo $MISSIONS_DIR
ls -l $MISSIONS_DIR
chmod +x ./run_bepinex.sh
./run_bepinex.sh -limitframerate 60 -ServerRemoteCommands 7779 -logFile server.log