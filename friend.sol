// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FindAFriend {
    struct Friend {
        address payable owner;
        string name;
        string description;
        uint256 pricePerHour;
        bool available;
    }

    Friend[] public friends;
    mapping(address => uint256) public rentals;

    event FriendListed(uint256 indexed friendId, address owner, string name, uint256 pricePerHour);
    event FriendRented(uint256 indexed friendId, address renter);

    // List yourself as a friend
    function listFriend(string memory _name, string memory _description, uint256 _pricePerHour) public {
        require(_pricePerHour > 0, "Price must be greater than zero");

        friends.push(Friend({
            owner: payable(msg.sender),
            name: _name,
            description: _description,
            pricePerHour: _pricePerHour,
            available: true
        }));

        emit FriendListed(friends.length - 1, msg.sender, _name, _pricePerHour);
    }

    // Rent a friend
    function rentFriend(uint256 _friendId) public payable {
        require(_friendId < friends.length, "Friend does not exist");
        Friend storage friend = friends[_friendId];
        require(friend.available, "Friend is not available");
        require(msg.value == friend.pricePerHour, "Incorrect amount sent");

        friend.owner.transfer(msg.value);
        friend.available = false;

        rentals[msg.sender] = _friendId;

        emit FriendRented(_friendId, msg.sender);
    }

    // Get details of a friend
    function getFriend(uint256 _friendId) public view returns (
        address owner,
        string memory name,
        string memory description,
        uint256 pricePerHour,
        bool available
    ) {
        require(_friendId < friends.length, "Friend does not exist");
        Friend storage friend = friends[_friendId];
        return (friend.owner, friend.name, friend.description, friend.pricePerHour, friend.available);
    }
}
