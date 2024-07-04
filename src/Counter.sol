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
    mapping(address => mapping(string => bool)) private exists;

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
            exists[contractAddress][records[i].variableName] = true;
        }
    }

    function getRecord(
        address contractAddress,
        string memory variableName
    ) public view returns (VariableData memory) {
        require(
            exists[contractAddress][variableName],
            "Variable name does not exist for the given contract address."
        );
        return contracts[contractAddress][variableName];
    }

    function computePrimitiveSlot(
        address contractAddress,
        string calldata key
    ) public view returns (VariableData memory) {
        return contracts[contractAddress][key];
    }

    function computeFixedArraySlot(
        address contractAddress,
        string calldata key,
        uint index
    ) public view returns (VariableData memory) {
        require(exists[contractAddress][key], "Variable does not exist");
        VariableData memory data = contracts[contractAddress][key];

        uint256 elementsPerSlot = 32 / data.numberOfBytes;
        uint256 slotOffset = index / elementsPerSlot;
        uint256 indexInSlot = index % elementsPerSlot;

        data.slotIndex += slotOffset;
        data.offset = indexInSlot * data.numberOfBytes;

        return data;
    }

    // function computeFixedArraySlot(
    //     address contractAddress,
    //     string calldata key,
    //     uint index
    // ) public view returns (VariableData memory) {
    //     VariableData memory data = contracts[contractAddress][key];
    //     uint256 slotIndex = data.slotIndex;

    //     data.slotIndex = slotIndex + index;
    //     return data;
    // }

    function computeDynamicArrayElementSlot(
        address contractAddress,
        string calldata key,
        uint index
    ) public view returns (VariableData memory) {
        VariableData memory data = contracts[contractAddress][key];
        uint256 slotIndex = data.slotIndex;

        data.slotIndex = uint(keccak256(abi.encodePacked(slotIndex))) + index;

        return data;
    }

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
