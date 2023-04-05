pragma solidity ^0.8.0;

contract DecentralizedNewsPlatform {
    address private owner; // 계약 소유자 주소
    uint public articleCount = 0; // 등록된 기사 수
    uint public commentCount = 0; // 등록된 댓글 수
    
    struct Article {
        uint id;
        string title;
        string content;
        uint timestamp;
        uint likes;
        uint dislikes;
        address author;
    }
    
    struct Comment {
        uint id;
        string content;
        uint timestamp;
        uint likes;
        uint dislikes;
        address author;
        uint articleId;
    }
    
    mapping (uint => Article) public articles; // 기사 정보 저장용 매핑
    mapping (uint => Comment) public comments; // 댓글 정보 저장용 매핑
    
    constructor() {
        owner = msg.sender;
    }
    
    // 기사 등록 함수
    function postArticle(string memory _title, string memory _content) public {
        require(bytes(_title).length > 0 && bytes(_content).length > 0, "Title or content cannot be empty.");
        
        articleCount++;
        articles[articleCount] = Article(articleCount, _title, _content, block.timestamp, 0, 0, msg.sender);
    }
    
    // 기사 수정 함수
    function updateArticle(uint _articleId, string memory _content) public {
        require(articles[_articleId].id != 0, "Article not found.");
        require(msg.sender == articles[_articleId].author, "Only the author can update the article.");
        
        articles[_articleId].content = _content;
    }
    
    // 기사 삭제 함수
    function deleteArticle(uint _articleId) public {
        require(articles[_articleId].id != 0, "Article not found.");
        require(msg.sender == articles[_articleId].author, "Only the author can delete the article.");
        
        delete articles[_articleId];
        articleCount--;
    }
    
    // 댓글 등록 함수
    function postComment(string memory _content, uint _articleId) public {
        require(bytes(_content).length > 0, "Comment cannot be empty.");
        require(articles[_articleId].id != 0, "Article not found.");
        
        commentCount++;
        comments[commentCount] = Comment(commentCount, _content, block.timestamp, 0, 0, msg.sender, _articleId);
    }
    
    // 댓글 수정 함수
    function updateComment(uint _commentId,
    string memory _content) public {
    require(comments[_commentId].id != 0, "Comment not found.");
    require(msg.sender == comments[_commentId].author, "Only the author can update the comment.");
    
    comments[_commentId].content = _content;
    }

    // 댓글 삭제 함수
    function deleteComment(uint _commentId) public {
        require(comments[_commentId].id != 0, "Comment not found.");
        require(msg.sender == comments[_commentId].author, "Only the author can delete the comment.");
        
        delete comments[_commentId];
        commentCount--;
    }

    // 기사 좋아요 함수
    function likeArticle(uint _articleId) public {
        require(articles[_articleId].id != 0, "Article not found.");
        require(msg.sender != articles[_articleId].author, "Author cannot like own article.");
        
        articles[_articleId].likes++;
    }

    // 기사 싫어요 함수
    function dislikeArticle(uint _articleId) public {
        require(articles[_articleId].id != 0, "Article not found.");
        require(msg.sender != articles[_articleId].author, "Author cannot dislike own article.");
        
        articles[_articleId].dislikes++;
    }

    // 댓글 좋아요 함수
    function likeComment(uint _commentId) public {
        require(comments[_commentId].id != 0, "Comment not found.");
        require(msg.sender != comments[_commentId].author, "Author cannot like own comment.");
        
        comments[_commentId].likes++;
    }

    // 댓글 싫어요 함수
    function dislikeComment(uint _commentId) public {
        require(comments[_commentId].id != 0, "Comment not found.");
        require(msg.sender != comments[_commentId].author, "Author cannot dislike own comment.");
        
        comments[_commentId].dislikes++;
    }

    // 계약 소유자 전용 함수
    function kill() public {
        require(msg.sender == owner, "Only contract owner can kill the contract.");
        
        selfdestruct(payable(owner));
    }
}