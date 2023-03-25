// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/**
 * @title BookRepository
 *  A contract called `Book Repository` has the complete list of Books. Below are its functionalities
 *   1. Given the ID get the Book details
 *   2. Each `Book` has the following details 
 *       1. Name
 *       2. Author
 *       3. Borrowed vs available. If borrowed by whom.
 *       4. Due Date if borrowed
 *       5. Book Id
 *   3. Only a librarian is allowed to add fresh copies to the repo or burn(make it not avaiable) it from the repo 
 *   4. Show the list of books
 *
 */

contract BookRepository {

    struct Book {
        uint256 bookId;
        uint256 dueDate;
        string author;
        string name;
        address borrowed;
    }

    address librarian;
    address lib;

    uint256 totalSupply = 0;

    Book[] public books;

    event BookAdded(uint256 bookId, string name, string author );
    event BookRemoved(uint256 bookId, string name, string author );

    constructor() {
        librarian = msg.sender;
    }

    modifier librarianOnly() {
        require(msg.sender == librarian,"Librarian only operation");
        _;
    }

    function setLibrary(address _library) external {
        lib = _library;
    }

    function getAllBooks() public view returns(Book[] memory) {
        return books;
    }

    function addBook(string calldata name, string calldata author) external librarianOnly {
        ++totalSupply;
        Book memory book = Book(totalSupply, 0, name, author, address(0));
        books.push(book);
        emit BookAdded(totalSupply, name, author);
    }

    function removeBook(uint256 bookId) external librarianOnly {
        Book memory tmp = books[bookId];
        delete books[bookId];
        emit BookRemoved(bookId, tmp.name, tmp.author);
    }

    function issueBook(uint256 bookId, address borrowedBy) external {
        require(msg.sender == lib,"Library only activity");
        Book storage b = books[bookId];
        b.borrowed = borrowedBy;
        b.dueDate = block.timestamp + 10 minutes;
    }

    function returnBook(uint256 bookId) external {
        require(msg.sender == lib,"Library only activity");
        Book storage b = books[bookId];
        b.borrowed = address(0);
        b.dueDate = 0;
    }             
}