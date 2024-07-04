#!/usr/bin/env bash
source .env && \

cast call \
    --legacy --rpc-url $ALCHEMY \
    --private-key $PRIVATE_KEY \
    $CONTRACT_ADDRESS "getRecord(address,string)((uint256,uint256,uint256,uint))" \
0x3333a2c812155aFB4f587af62444441a29FB4f2a "variableName1"