QUOTA=1
INDEX=1
SERVERPORT=7785
QUERYPORT=7786
RCONPORT=50005
CPU1=4
CPU2=5
for ((INDEX=1;INDEX<$QUOTA+1;INDEX++)); do
    sudo docker run -d \
        --cpuset-cpus=$CPU1,$CPU2 \
        -p $SERVERPORT-$QUERYPORT:$SERVERPORT-$QUERYPORT/udp \
        -p $SERVERPORT-$QUERYPORT:$SERVERPORT-$QUERYPORT/tcp \
        -p $RCONPORT-$RCONPORT:$RCONPORT-$RCONPORT/tcp \
        -v "$(pwd)/PvEMission":/missions \
        -v "$(pwd)/banlist":/banlist \
        -v "$(pwd)/replays":/replays \
        -v "$(pwd)/serverlog":/serverlog noserver \
        --modded false \
        --name "BROCCOLI DEFROST FORCE PVE "$INDEX"" \
        --password ""\
        --portOverride true \
        --portValue $SERVERPORT \
        --queryOverride true \
        --queryValue $QUERYPORT \
        --maxplayers 16 \
        --noStopTime 0 \
        --rconPort $RCONPORT \
        --rconPassword "defaultpassword" \
        --fpsLimit 60 \
        --rotationType 2

    ((SERVERPORT=$SERVERPORT + 2))
    ((QUERYPORT=$QUERYPORT + 2))
    ((RCONPORT++))
    ((CPU1=$CPU1+2))
    ((CPU2=$CPU2+2))
done