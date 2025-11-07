QUOTA=4
INDEX=1
SERVERPORT=7780
QUERYPORT=7781
RCONPORT=50000
CPU1=0
CPU2=1
for ((INDEX=1;INDEX<$QUOTA+1;INDEX++)); do
    sudo docker run -d \
        --cpuset-cpus=$CPU1,$CPU2 \
        -p $SERVERPORT-$QUERYPORT:$SERVERPORT-$QUERYPORT/udp \
        -p $SERVERPORT-$QUERYPORT:$SERVERPORT-$QUERYPORT/tcp \
        -p $RCONPORT-$RCONPORT:$RCONPORT-$RCONPORT/tcp \
        -v "$(pwd)/dogfightMission":/missions \
        -v "$(pwd)/banlist":/banlist \
        -v "$(pwd)/replays":/replays noserver \
        --modded true \
        --name "BROCCOLI DEFROST FORCE DOGFIGHT #"$INDEX"" \
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

    ((SERVERPORT=$SERVERPORT + 2))
    ((QUERYPORT=$QUERYPORT + 2))
    ((RCONPORT++))
    ((CPU1=$CPU1+2))
    ((CPU2=$CPU2+2))
done
    