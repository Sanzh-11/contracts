// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TaskManagement {
    struct Task {
        string description;
        address assignedTo;
        uint reward;
        bool completed;
    }

    address public owner;
    mapping(uint => Task) public tasks;
    uint public taskCount;
    mapping(address => uint) public balances;

    event TaskCreated(uint taskId, string description, address assignedTo, uint reward);
    event TaskCompleted(uint taskId, address completedBy);
    event TokensRewarded(address recipient, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createTask(string memory _description, address _assignedTo, uint _reward) public onlyOwner {
        taskCount++;
        tasks[taskCount] = Task(_description, _assignedTo, _reward, false);
        emit TaskCreated(taskCount, _description, _assignedTo, _reward);
    }

    function completeTask(uint _taskId) public {
        Task storage task = tasks[_taskId];
        require(msg.sender == task.assignedTo, "You are not assigned to this task");
        require(!task.completed, "Task is already completed");

        task.completed = true;
        balances[msg.sender] += task.reward;

        emit TaskCompleted(_taskId, msg.sender);
        emit TokensRewarded(msg.sender, task.reward);
    }

    function checkBalance(address _user) public view returns (uint) {
        return balances[_user];
    }

    function withdrawTokens() public {
        uint balance = balances[msg.sender];
        require(balance > 0, "No tokens to withdraw");
        balances[msg.sender] = 0;
    }
}
