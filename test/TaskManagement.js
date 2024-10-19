const { expect } = require("chai");

describe("TaskManagement", function () {
  it("Should let both parties sign the contract", async function () {
    const TaskManagement = await ethers.getContractFactory("TaskManagement");
    const [owner, party1, party2] = await ethers.getSigners();

    const contract = await TaskManagement.deploy();
    await contract.deployed();

    await contract.createTask("Test Task", party1.address, 100);
    await contract.connect(party1).completeTask(1);

    const balance = await contract.checkBalance(party1.address);
    expect(balance).to.equal(100);
  });
});
