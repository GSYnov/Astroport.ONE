#!/bin/bash

## SHOW DHT STATS
echo "------------------------------------------------- ~/.zen/tmp/ipfs.stats.dht.wan"
echo "GETTING DHT STATS"
ipfs stats dht wan > ~/.zen/tmp/ipfs.stats.dht.wan
# cat ~/.zen/tmp/ipfs.stats.dht.wan

## BOOSTRAP
echo "-------------------------------------------------"
echo "SWARM NODES"
for bootnode in $(cat ~/.zen/Astroport.ONE/A_boostrap_nodes.txt | grep -Ev "#" | grep -v '^[[:space:]]*$')
do
    echo
    ipfsnodeid=${bootnode##*/}
    ipfs swarm peers | grep $bootnode
    ipfs --timeout 15s ping -n 3 $bootnode
    [ $? = 0 ] && ipfs swarm connect $bootnode \
                    || echo "BAD NODE $bootnode"
    echo "*****"
    echo "in DHT ? --------------"
    cat ~/.zen/tmp/ipfs.stats.dht.wan | grep $ipfsnodeid
    echo "-------------------------------------------------"

done

## SWARM
echo
echo "-------------------------------------------------"
echo "SWARM NODES"
for ipfsnodeid in $(ls ~/.zen/tmp/swarm);
do
    ipfs --timeout 15s ping -n 3 /p2p/$ipfsnodeid
    [ $? = 0 ] && ipfs swarm connect /p2p/$ipfsnodeid \
                    || echo "BAD NODE $ipfsnodeid"
    echo "in DHT ? --------------"
    cat ~/.zen/tmp/ipfs.stats.dht.wan | grep $ipfsnodeid
    echo "-------------------------------------------------"
done
