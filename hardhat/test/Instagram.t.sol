// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;
import {Test} from "forge-std/Test.sol";
import {Instagram} from "../contracts/Instagram.sol";

contract InstagramTest is Test {
    Instagram public instagram;

    event PostAdded(uint256 indexed postId, string description, address owner);
    event Like(uint256 indexed postId, address user);
    event Unlike(uint256 indexed postId, address user);

    function setUp() public {
        instagram = new Instagram();
    }

    function testFail_AddPost() external {
        Instagram.Post memory post = Instagram.Post("desc1", "");
        instagram.addPost(post);
    }

    function testAddPost() external {
        Instagram.Post memory post = Instagram.Post("desc1", "uri");

        vm.expectEmit(true, false, false, false);
        emit PostAdded(
            instagram.s_postCounterId() + 1,
            post.description,
            address(this)
        );
        instagram.addPost(post);
        assertEq(instagram.s_postCounterId(), 1);
        Instagram.Post memory _post = instagram.getPost(1);
        assertEq(_post.description, "desc1");
        assertEq(_post.uri, "uri");
    }

    function testLikePost() external {
        uint256 postId = 1;
        _addPost();
        vm.expectEmit(true, false, false, false);
        emit Like(postId, address(this));
        instagram.like(postId);
        uint256 likes = instagram.getLikesOfPost(postId);
        assertEq(likes, 1);
    }

    function testUnlikePost() external {
        uint256 postId = 1;
        _addPost();
        instagram.like(postId);
        vm.expectEmit(true, false, false, false);
        emit Unlike(postId, address(this));
        instagram.unlike(postId);
        uint256 likes = instagram.getLikesOfPost(postId);
        assertEq(likes, 0);
    }

    function testFailGetPost() external {
        _addPost();
        instagram.getPost(2);
    }

    function testGetPost() external {
        uint256 postId = 1;
        _addPost();
        Instagram.Post memory post = instagram.getPost(postId);
        assertEq(post.description, "description");
        assertEq(post.uri, "uri");
    }

    function testGetPostUser() external {
        uint256 postId = 1;
        _addPost();
        Instagram.Post memory post = instagram.getPostUser(
            address(this),
            postId
        );
        assertEq(post.description, "description");
        assertEq(post.uri, "uri");
    }

    function testGetPostsCounterByUser() external {
        _addPost();
        uint256 counter = instagram.getPostsCounterByUser(address(this));
        assertEq(counter, 1);
    }

    function testGetLikesOfPost() external {
        uint256 postId = 1;
        _addPost();
        instagram.like(postId);
        uint256 likes = instagram.getLikesOfPost(postId);
        assertEq(likes, 1);
    }

    function testGetUri() external {
        uint256 postId = 1;
        _addPost();
        string memory uri = instagram.getUri(postId);
        assertEq(uri, "uri");
    }

    function testFailGetUri() external {
        _addPost();
        instagram.getUri(2);
    }

    function testFailGetLikesOfPost() external {
        _addPost();
        instagram.getLikesOfPost(2);
    }

    function testGetAllPosts() external {
        _addPost();
        _addPost();
        Instagram.Post[] memory posts = instagram.getAllPosts(0, 1);
        assertEq(posts.length, 2);
    }

    function _addPost() internal {
        Instagram.Post memory post = Instagram.Post({
            description: "description",
            uri: "uri"
        });
        instagram.addPost(post);
    }
}
