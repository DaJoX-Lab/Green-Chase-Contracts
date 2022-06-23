

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
    using Strings for uint256;
    
    // Optional mapping for token URIs
    mapping (uint256 => string) private _tokenURIs;

    // Base URI
    string private _baseURIextended;



    constructor(address _child,string memory name_, string memory symbol_) ERC721(name_, symbol_) payable {
        companyname = name_;
        companyAddr = address(this);
        origin = address(msg.sender);
        child =address(_child);
    }
     function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }
    
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    } 
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();
        
        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

        
    function safeMint(string memory tokenURI_) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI_);

    }

    function CreateChild(address _owner,string memory _name, string memory _symbol,string memory tokenURI_) public onlyOwner{
        Greenchase c = Greenchase(origin);
        c.createchild(_owner,_name,_symbol);
        safeMint(tokenURI_);
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
