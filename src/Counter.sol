// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    struct VariableData {
        uint256 slotIndex;
        uint256 offset;
        uint256 length;
        uint numberOfBytes;
    }

    struct VariableRecord {
        string variableName;
        uint256 slotIndex;
        uint256 offset;
        uint256 length;
        uint numberOfBytes;
    }

    mapping(address => mapping(string => VariableData)) public contracts;

    function addRecords(
        address contractAddress,
        VariableRecord[] memory records
    ) public {
        for (uint256 i = 0; i < records.length; i++) {
            contracts[contractAddress][records[i].variableName] = VariableData(
                records[i].slotIndex,
                records[i].offset,
                records[i].length,
                records[i].numberOfBytes
            );
        }
    }

    function getRecord(
        address contractAddress,
        string memory variableName
    ) public view returns (VariableData memory) {
        return contracts[contractAddress][variableName];
    }

    function computePrimitiveSlot(
        address contractAddress,
        string calldata key
    ) public view returns (VariableData memory) {
        return contracts[contractAddress][key];
    }

    // function computeFixedArraySlot(
    //     address contractAddress,
    //     string calldata key
    // ) public view returns (uint) {
    //     VariableData memory data = contracts[contractAddress][key];
    //      uint256 slotIndex = data.slotIndex;
    //     uint256 offset = data.offset;
    //     uint256 length = data.length;

    //     // return baseSlot + index;
    // }

    // function computeDynamicArrayElementSlot(
    //     address contractAddress,
    //     string calldata key
    // ) public view returns (uint) {
    //     VariableData memory data = contracts[contractAddress][key];
    //     uint256 slotIndex = data.slotIndex;
    //     uint256 offset = data.offset;
    //     uint256 length = data.length;

    //     return uint(keccak256(abi.encodePacked(baseSlot))) + index;
    // }

    function computeMappingSlot(
        address contractAddress,
        string calldata key
    ) public view returns (VariableData memory) {
        VariableData memory data = contracts[contractAddress][key];

        uint256 slotIndex = data.slotIndex;

        data.slotIndex = uint(keccak256(abi.encodePacked(key, slotIndex)));

        return data;
    }

    // function computePackedArraySlot(
    //     uint baseSlot,
    //     uint index,
    //     uint elementSize
    // ) public pure returns (uint) {
    //     uint elementsPerSlot = 32 / elementSize;
    //     return baseSlot + (index / elementsPerSlot);
    // }

    // function computePackedArrayOffset(
    //     uint index,
    //     uint elementSize
    // ) public pure returns (uint) {
    //     uint elementsPerSlot = 32 / elementSize;
    //     return (index % elementsPerSlot) * elementSize;
    // }
}
