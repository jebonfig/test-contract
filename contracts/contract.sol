pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Registry is Ownable, Initializable {
    event CollectionCreated(
        string indexed collectionName,
        address indexed collectionAddress,
        address indexed contractTemplateAddress
    );
    string public name;
    address public membershipToken;

    mapping(string => address) public collections;

    function initialize(string memory _name, address _owner)
        public
        initializer
    {
        Ownable(_owner);
        name = _name;
    }

    function createCollection(
        string memory collectionName,
        address contractTemplateAddress
    ) public onlyOwner returns (address _thing) {
        require(
            collections[collectionName] == address(0),
            "Collection already exists"
        );
        require(
            contractTemplateAddress != address(0),
            "Contract template is not valid"
        );

        address collectionAddress = Clones.clone(contractTemplateAddress);
        emit CollectionCreated(
            collectionName,
            collectionAddress,
            contractTemplateAddress
        );
        collections[collectionName] = collectionAddress;
        return contractTemplateAddress;
    }
}
