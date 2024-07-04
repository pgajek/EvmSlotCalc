#!/usr/bin/env bash
source .env && \

cast send \
    --legacy --rpc-url $ALCHEMY \
    --private-key $PRIVATE_KEY \
    $CONTRACT_ADDRESS "addRecords(address,(string,uint256,uint256,uint256,uint)[])" \
0x3333a2c812155aFB4f587af62444441a29FB4f2a "[("variableName1",1,10,32,32),("variableName2",1,10,32,32),("variableName3",2,10,32,32)]"