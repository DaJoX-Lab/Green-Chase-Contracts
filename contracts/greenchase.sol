

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CompanyContract is ERC721, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string public companyname;
    address public companyAddr;
    address public origin;
    address public child;

    constructor(address _child,string memory name_, string memory symbol_) ERC721(name_, symbol_) payable {
        companyname = name_;
        companyAddr = address(this);
        origin = address(msg.sender);
        child =address(_child);
    }

        
    function safeMint() public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function CreateChild(address _owner,string memory _name, string memory _symbol) public onlyOwner{
        Greenchase c = Greenchase(origin);
        c.createchild(_owner,_name,_symbol);
        safeMint();
    }
}

contract Greenchase {
    CompanyContract[] public companycontracts;

    function create(string memory _name, string memory _symbol) public {
        CompanyContract company = new CompanyContract(address(this),_name, _symbol);
        company.transferOwnership(msg.sender);
        companycontracts.push(company);
    }
    function createchild(address _owner,string memory _name, string memory _symbol) public{
        CompanyContract company = new CompanyContract(msg.sender,_name, _symbol);
        company.transferOwnership(_owner);
        companycontracts.push(company);
    }
    function getCompany(uint _index)
        public
        view
        returns (
            address owner,
            string memory companyname,
            address companyAddr,
            address child,
            uint balance
        )
    {
        CompanyContract company = companycontracts[_index];
        return (company.owner(), company.companyname(), company.companyAddr(), company.child() ,address(company).balance);
    }
}
