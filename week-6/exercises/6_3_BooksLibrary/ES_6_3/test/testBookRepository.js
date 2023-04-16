const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFixture() {

    // Contracts are deployed using the first signer/account by default
    const [librarian, otherAccount, member] = await ethers.getSigners();

    const BookRepositoryFactory = await ethers.getContractFactory("BookRepository");
    const bRepo = await BookRepositoryFactory.deploy();

    return { bRepo, librarian, otherAccount, member };
  }

  describe("Deployment", function () {
    it("Only librarian can set the library address ", async function () {
      const { bRepo, librarian, otherAccount } = await loadFixture(deployFixture);

      expect (await bRepo.lib()).to.be.equal(ethers.constants.AddressZero);
      
      await expect(bRepo.connect(otherAccount).setLibrary(otherAccount.address)).to.be.revertedWith("Librarian only operation");

      await bRepo.connect(librarian).setLibrary(otherAccount.address);
      
      expect (await bRepo.lib()).to.be.equal(otherAccount.address);

    });

    it("Only librarian can add/remove Book to/from repository ", async function () {
      const { bRepo, librarian } = await loadFixture(deployFixture);

      await bRepo.connect(librarian).addBook("ABC","XYZ");
      await bRepo.connect(librarian).addBook("DEF","UVW");

      let books = await bRepo.getAllBooks();

      expect(books.length).to.be.eq(2);

      console.log(`There are ${books.length} books in library`);
      
      books.forEach(book => {
        console.log(`**********************`);
        console.log(book);
      });

      await bRepo.connect(librarian).removeBook(1);
      books = await bRepo.getAllBooks();

      expect(books.length).to.be.eq(2);

      console.log(`There are ${books.length} books in library`);
      
      books.forEach(book => {
        console.log(`**********************`);
        console.log(book);
      });
    });

    it("non librarian to add/remove book reverts ", async function () {
      const { bRepo, otherAccount } = await loadFixture(deployFixture);

      await expect(bRepo.connect(otherAccount).addBook("ABC","XYZ")).to.be.revertedWith("Librarian only operation");

      await expect(bRepo.connect(otherAccount).removeBook(1)).to.be.revertedWith("Librarian only operation");
    });

    it("library can issue and return books", async function () {
      const { bRepo, librarian, otherAccount, member } = await loadFixture(deployFixture);

      await bRepo.connect(librarian).setLibrary(otherAccount.address);
      expect (await bRepo.lib()).to.be.equal(otherAccount.address);

      await bRepo.connect(librarian).addBook("ABC","XYZ");
      await bRepo.connect(librarian).addBook("DEF","UVW");

      await bRepo.connect(otherAccount).issueBook(0, member.address);
      await bRepo.connect(otherAccount).issueBook(1, member.address);

      let books = await bRepo.getAllBooks();

      expect(books[0].bookId).to.be.eq(0);
      expect(books[0].borrowed).to.be.eq(member.address);

      expect(books[1].bookId).to.be.eq(1);
      expect(books[1].borrowed).to.be.eq(member.address);

      await bRepo.connect(otherAccount).returnBook(0);

      books = await bRepo.getAllBooks();

      expect(books[0].bookId).to.be.eq(0);
      expect(books[0].borrowed).to.be.eq(ethers.constants.AddressZero);

    });

    it("only library can issue and return books, other revert", async function () {
      const { bRepo, librarian, otherAccount, member } = await loadFixture(deployFixture);

      await bRepo.connect(librarian).setLibrary(otherAccount.address);
      expect (await bRepo.lib()).to.be.equal(otherAccount.address);

      await bRepo.connect(librarian).addBook("ABC","XYZ");
      await bRepo.connect(librarian).addBook("DEF","UVW");

      await expect( bRepo.connect(member).issueBook(0, member.address)).to.be.revertedWith("Library only activity");

      await expect(bRepo.connect(member).returnBook(0)).to.be.revertedWith("Library only activity");
    }); 

    it("test for book data", async function () {
      const { bRepo, librarian, otherAccount, member } = await loadFixture(deployFixture);

      await bRepo.connect(librarian).setLibrary(otherAccount.address);
      expect (await bRepo.lib()).to.be.equal(otherAccount.address);

      await bRepo.connect(librarian).addBook("ABC","XYZ");
      await bRepo.connect(librarian).addBook("DEF","UVW");

      const book0 = await bRepo.books(0);
      console.log(book0);

      const book1 = await bRepo.books(1);
      console.log(book1);
    }); 
  });
});
