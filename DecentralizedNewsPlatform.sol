pragma solidity ^0.8.0;

contract DecentralizedNewsPlatform {
    
    struct News {
        address author;
        string title;
        string content;
        uint votes;
        bool isVerified;
        bool exists;
    }
    
    mapping (bytes32 => News) private newsList; // Mapping to store the news
    
    function addNews(string memory _title, string memory _content) public {
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, _title, _content)); // Hash the news
        require(!newsList[hash].exists, "News already exists!"); // Check if the news already exists
        News memory newNews = News(msg.sender, _title, _content, 0, false, true); // Create a new News struct
        newsList[hash] = newNews; // Add the news to the mapping
    }
    
    function verifyNews(bytes32 _hash) public {
        require(newsList[_hash].exists, "News does not exist!"); // Check if the news exists
        require(msg.sender != newsList[_hash].author, "Author cannot verify their own news!"); // Check if the author is not verifying their own news
        require(!newsList[_hash].isVerified, "News is already verified!"); // Check if the news is not already verified
        newsList[_hash].votes++; // Increment the vote count
        if (newsList[_hash].votes >= 3) { // If the votes reach 3
            newsList[_hash].isVerified = true; // Verify the news
        }
    }
    
    function getNews(bytes32 _hash) public view returns(address, string memory, string memory, uint, bool, bool) {
        return (newsList[_hash].author, newsList[_hash].title, newsList[_hash].content, newsList[_hash].votes, newsList[_hash].isVerified, newsList[_hash].exists);
    }
}
