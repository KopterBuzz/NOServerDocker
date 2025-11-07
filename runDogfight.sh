QUOTA=4
INDEX=1
SERVERPORT=7780
QUERYPORT=7781
RCONPORT=50000

for ((INDEX=1;INDEX<$QUOTA+1;INDEX++)); do
    sudo docker run -d \
        --cpuset-cpus=0,1 \
        -p $SERVERPORT-$SERVERPORT:$QUERYPORT-$QUERYPORT/udp \
        -p $SERVERPORT-$SERVERPORT:$QUERYPORT-$QUERYPORT/tcp \
        -p $RCONPORT-$RCONPORT:$RCONPORT-$RCONPORT/tcp \
        -v "$(pwd)/dogfightMission":/missions \
        -v "$(pwd)/banlist":/banlist \
        -v "$(pwd)/replays":/replays noserver \
        --modded true \
        --name "[EU]Broccoli Defrost Force Dogfight #$INDEX" \
        --password ""\
        --port-override true \
        --port-value $SERVERPORT \
        --query-override true \
        --query-value $QUERYPORT \
        --maxplayers 8 \
        --nostoptime 0 \
        --rconPort $RCONPORT \
        --rconPassword "defaultpassword" \
        --fpsLimit 60 \
        --rotationType 2

    ((SERVERPORT=$SERVERPORT + 2))
    ((QUERYPORT=$QUERYPORT + 2))
    ((RCONPORT++))
done
    