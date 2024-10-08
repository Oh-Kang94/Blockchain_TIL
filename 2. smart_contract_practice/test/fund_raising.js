const { expect } = require("chai");
const { ethers } = require("hardhat");

// 
describe("FundRaising", function () {
  let FundRaising;
  let fundraising;
  let owner;
  let addr1;
  let addr2;
  let addr3;

  const TARGET_AMOUNT = ethers.parseEther("1");  // 1 ETH
  const DECIMAL_ONE_ETH = ethers.parseEther("0.1");
  const TWO_WEEKS = 2 * 7 * 24 * 60 * 60;

  // Flutter 에서 SetupAll과 같음
  beforeEach(async function () {
    [owner, addr1, addr2, ...addr3] = await ethers.getSigners(); // 첫번째 주소는 알아서, owner로 간주한다.

    FundRaising = await ethers.getContractFactory("FundRaising"); // Contract 생성
    fundraising = await FundRaising.deploy(TARGET_AMOUNT);
  });

  // Flutter 에서 group과 같음 여기선 Phase를 나타냄
  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      // 본인이 맞는지 확인
      // fundraising.owner()가 address public owner를 가져올 수 있는 이유는 
      // `.sol`에서 가져오는 것 중 public 선언은 모두 Getter 형태로 가져온다.
      expect(await fundraising.owner()).to.equal(owner.address);
    });

    it("Should set the correct target amount", async function () {
      expect(await fundraising.targetAmount()).to.equal(TARGET_AMOUNT);
    });
  });

  describe("Donations", function () {
    it("Should allow donations and update balances", async function () {
      await addr1.sendTransaction({
        to: fundraising.target, // fundraising.address 와 같은 의미
        value: DECIMAL_ONE_ETH
      });

      expect(await fundraising.raisedAmount()).to.equal(DECIMAL_ONE_ETH);
      expect(await fundraising.balanceOf(addr1.address)).to.equal(DECIMAL_ONE_ETH);
    });

    it("Should allow multiple donations from the same address", async function () {
      await addr1.sendTransaction({
        to: fundraising.target,
        value: DECIMAL_ONE_ETH
      });

      await addr1.sendTransaction({
        to: fundraising.target,
        value: DECIMAL_ONE_ETH
      });

      expect(await fundraising.balanceOf(addr1.address)).to.equal(DECIMAL_ONE_ETH * BigInt(2));
    });

    it("Should not allow donations after finish time", async function () {
      await ethers.provider.send("evm_increaseTime", [TWO_WEEKS + 1]); // 가상으로 시간을 2주뒤로 넘기는 것
      await ethers.provider.send("evm_mine"); // setState

      await expect(
        addr1.sendTransaction({
          to: fundraising.target,
          value: DECIMAL_ONE_ETH
        })
      ).to.be.revertedWith("This campaign is over"); // refund 함수에서 넘어 갈것이다. 
    });
  });

  describe("Withdrawals", function () {
    it("Should allow owner to withdraw if goal is reached and campaign is over", async function () {
      // Fund the campaign
      await addr1.sendTransaction({
        to: fundraising.target,
        value: TARGET_AMOUNT
      });

      // Fast forward time
      await ethers.provider.send("evm_increaseTime", [TWO_WEEKS + 1]);
      await ethers.provider.send("evm_mine");

      await expect(fundraising.withdrawDonations())
        .to.changeEtherBalances(
          [fundraising, owner],
          [-TARGET_AMOUNT, TARGET_AMOUNT]
        );
    });

    it("Should not allow withdrawal if goal is not reached", async function () {
      await addr1.sendTransaction({
        to: fundraising.target,
        value: DECIMAL_ONE_ETH
      });

      await ethers.provider.send("evm_increaseTime", [TWO_WEEKS + 1]);
      await ethers.provider.send("evm_mine");

      await expect(
        fundraising.withdrawDonations()
      ).to.be.revertedWith("The project did not reach the goal");
    });

    it("Should not allow non-owner to withdraw", async function () {
      await addr1.sendTransaction({
        to: fundraising.target,
        value: TARGET_AMOUNT
      });

      await ethers.provider.send("evm_increaseTime", [TWO_WEEKS + 1]);
      await ethers.provider.send("evm_mine");

      await expect(
        fundraising.connect(addr1).withdrawDonations()
      ).to.be.revertedWith("Funds will only be released to the owner");
    });
  });

  describe("Refunds", function () {
    beforeEach(async function () {
      await addr1.sendTransaction({
        to: fundraising.target,
        value: DECIMAL_ONE_ETH
      });
    });

    it("Should allow refund if goal is not reached and campaign is over", async function () {
      await ethers.provider.send("evm_increaseTime", [TWO_WEEKS + 1]);
      await ethers.provider.send("evm_mine");

      // fundraising 에 addr1을 연결해서, refund 라는 함수를 call 하는 것
      // .sol 참조
      await expect(fundraising.connect(addr1).refund())
        .to.changeEtherBalances(
          [fundraising, addr1],
          [-DECIMAL_ONE_ETH, DECIMAL_ONE_ETH]
        );
      /**
        await expect(transaction).to.changeEtherBalances([address1, address2], [amount1, amount2]);
        transaction: 잔액 변화를 확인하고자 하는 트랜잭션을 지정.
        [address1, address2]: 잔액 변화를 확인할 주소들의 배열.
        [amount1, amount2]: 각 주소에 대해 예상되는 잔액 변화량을 나타내는 배열입니다.
       */
    });

    it("Should not allow refund if campaign is not over", async function () {
      await expect(
        fundraising.connect(addr1).refund()
      ).to.be.revertedWith("The campaign is not over yet");
    });

    it("Should not allow refund if goal is reached", async function () {
      await addr2.sendTransaction({
        to: fundraising.target,
        value: TARGET_AMOUNT
      });

      await ethers.provider.send("evm_increaseTime", [TWO_WEEKS + 1]);
      await ethers.provider.send("evm_mine");

      await expect(
        fundraising.connect(addr1).refund()
      ).to.be.revertedWith("The campaign reached the goal");
    });

    it("Should not allow refund for non-donors", async function () {
      await ethers.provider.send("evm_increaseTime", [TWO_WEEKS + 1]);
      await ethers.provider.send("evm_mine");

      await expect(
        fundraising.connect(addr2).refund()
      ).to.be.revertedWith("you did not donate to this campaign");
    });
  });
});