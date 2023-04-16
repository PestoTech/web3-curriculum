const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Book Library", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFixture() {
    const ONE_ETH = ethers.utils.parseEther("1");
    const MEMBER_FEE = ethers.utils.parseEther("5");


    // Contracts are deployed using the first signer/account by default
    const [librarian, otherAccount, member1, member2] = await ethers.getSigners();

    const BookRepositoryFactory = await ethers.getContractFactory("BookRepository");
    const bRepo = await BookRepositoryFactory.deploy();

    const BookLibraryFactory = await ethers.getContractFactory("BookLibrary");
    const bLib = await BookLibraryFactory.deploy(bRepo.address);

    await bRepo.setLibrary(bLib.address);

    return { bRepo, bLib, librarian, otherAccount, member1, member2, ONE_ETH, MEMBER_FEE };
  }

  describe("Deployment", function () {
    it("Check for deployment state", async function () {
      const { bRepo, bLib, librarian } = await loadFixture(deployFixture);

      expect(await bLib.libRepo()).to.equal(bRepo.address);
      expect(await bLib.librarian()).to.equal(librarian.address);
      expect(await bLib.fineAmount()).to.equal(0);
    });

    it("Anybody can be member with enough ether", async function () {
      const { bLib, member1, ONE_ETH, MEMBER_FEE } = await loadFixture(deployFixture);

      await expect(bLib.connect(member1).memberRegistration()).to.be.revertedWith("Pay required fee");
      await expect(bLib.connect(member1).memberRegistration({value: ONE_ETH})).to.be.revertedWith("Pay required fee");
      await bLib.connect(member1).memberRegistration({value: MEMBER_FEE});

      //memeber cannot be a member again
      await expect(bLib.connect(member1).memberRegistration({value: MEMBER_FEE})).to.be.revertedWith("Already a member");
      
    });
  });

  describe("Funtionality", function () {
    it("Borrow and its cases", async function () {
      const { bRepo, bLib, librarian, otherAccount, member1, member2, ONE_ETH, MEMBER_FEE } = await loadFixture(deployFixture);

      // members register
      await bLib.connect(member1).memberRegistration({value: MEMBER_FEE});
      await bLib.connect(member2).memberRegistration({value: MEMBER_FEE});
      //add books
      await bRepo.connect(librarian).addBook("ABC","XYZ");
      await bRepo.connect(librarian).addBook("DEF","UVW");
      await bRepo.connect(librarian).addBook("AAA","ZZZ");
      await bRepo.connect(librarian).addBook("BBB","AZZ");

      let books = await bRepo.getAllBooks();

      expect(books.length).to.be.eq(4);

      // borrow
      await expect(bLib.connect(member1).borrowBook(3)).to.emit(bLib, "BookBorrowed")
        .withArgs(member1.address, 3);

      // cannot borrow preivously borrowed books
      await expect(bLib.connect(member2).borrowBook(3)).to.be.revertedWith("Book is already borrowed");
        
      await bRepo.connect(librarian).removeBook(1);

      await expect(bLib.connect(member2).borrowBook(1)).to.be.revertedWith("Book is burnt from library");

      await expect(bLib.connect(member1).borrowBook(2)).to.emit(bLib, "BookBorrowed");

      await expect(bLib.connect(member1).borrowBook(0)).to.be.revertedWith("Borrow limit exceeded");
    });

    it("Return and its cases", async function () {
      const { bRepo, bLib, librarian, otherAccount, member1, member2, ONE_ETH, MEMBER_FEE } = await loadFixture(deployFixture);

      // members register
      await bLib.connect(member1).memberRegistration({value: MEMBER_FEE});
      await bLib.connect(member2).memberRegistration({value: MEMBER_FEE});
      //add books
      await bRepo.connect(librarian).addBook("ABC","XYZ");
      await bRepo.connect(librarian).addBook("DEF","UVW");
      await bRepo.connect(librarian).addBook("AAA","ZZZ");
      await bRepo.connect(librarian).addBook("BBB","AZZ");

      let books = await bRepo.getAllBooks();

      const borrowTime = await time.latest();
      // borrow
      await bLib.connect(member1).borrowBook(3);
      await bLib.connect(member1).borrowBook(2);
      await bRepo.connect(librarian).removeBook(1);
      
      // retunring a book not owned by member
      await expect(bLib.connect(member1).returnBook(1)).to.be.revertedWith("Not Borrowed by member");
      
      const validReturnTime = borrowTime + 500;
      await time.increaseTo(validReturnTime);

      await expect(bLib.connect(member1).returnBook(2)).to.emit(bLib, "BookReturned");
      expect(await bLib.balance(member1.address)).to.be.eq(MEMBER_FEE);

      const invalidReturnTime = borrowTime + 1000;
      await time.increaseTo(invalidReturnTime);

      await expect(bLib.connect(member1).returnBook(3)).to.emit(bLib, "BookReturned");
      expect(await bLib.balance(member1.address)).to.be.eq(MEMBER_FEE.sub(ONE_ETH));

    });
  });
});
