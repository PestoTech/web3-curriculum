// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

// import "hardhat/console.sol";

interface IRepo {
    function issueBook(uint256 bookId, address borrowedBy) external;

    function returnBook(uint256 bookId) external;

    function getBookInfo(uint256 bookId) external returns (Book memory);
}

struct Book {
    uint256 bookId;
    uint256 dueDate;
    string author;
    string name;
    address borrowed;
}

/**
 * @title BookLibrary
 *  A contract called `Library` allows only the members of the library to borrow books via the library contract.
 *   1. One can become a member after paying a small fee of 5 ETH.
 *   2. One address can borrow only 2 books
 *   3. Any late returns beyond due date are fined at 1 ETH, that shall be deducted from the member balance
 *   4. Librarian can withdraw the fine amount for library expenses
 *   5. A member can cancel the member ship and reclaim his remaining balance after returning the books.
 *
 */

contract BookLibrary {
    address public librarian;
    IRepo public libRepo;
    uint256 public fineAmount;

    mapping(address => uint256) public balance;
    mapping(address => uint256[2]) public borrowedBooks;

    event BookBorrowed(address member, uint256 bookId);
    event BookReturned(address member, uint256 bookId);

    constructor(address repo) {
        librarian = msg.sender;
        libRepo = IRepo(repo);
    }

    modifier librarianOnly() {
        require(msg.sender == librarian, "Librarian only operation");
        _;
    }

    function memberRegistration() external payable {
        require(msg.value == 5 ether, "Pay required fee");
        require(balance[msg.sender] == 0, "Already a member");
        balance[msg.sender] = msg.value;
    }

    function borrowBook(uint256 bookId) external {
        require(balance[msg.sender] >= 1 ether, "Not a member");
        uint256[2] storage bBooks = borrowedBooks[msg.sender];

        Book memory b = libRepo.getBookInfo(bookId);
        require(b.bookId == bookId, "Book is burnt from library");
        require(b.dueDate == 0, "Book is already borrowed");
        require(bBooks[0] == 0 || bBooks[1] == 0, "Borrow limit exceeded");

        if (bBooks[0] == 0) {
            bBooks[0] = bookId;
        } else {
            bBooks[1] = bookId;
        }

        libRepo.issueBook(bookId, msg.sender);
        emit BookBorrowed(msg.sender, bookId);
    }

    function returnBook(uint256 bookId) external {
        require(balance[msg.sender] >= 1 ether, "Not a member");
        uint256[2] storage bBooks = borrowedBooks[msg.sender];
        require(
            bBooks[0] == bookId || bBooks[1] == bookId,
            "Not Borrowed by member"
        );

        Book memory b = libRepo.getBookInfo(bookId);
        require(b.borrowed == msg.sender, "Where is the member?");
        if (block.timestamp > b.dueDate) {
            balance[msg.sender] -= 1 ether;
            fineAmount += 1 ether;
        }

        if (bBooks[0] == bookId) {
            bBooks[0] = 0;
        } else {
            bBooks[1] = 0;
        }

        libRepo.returnBook(bookId);
        emit BookReturned(msg.sender, bookId);
    }
}
