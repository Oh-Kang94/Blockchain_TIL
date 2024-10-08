// SPDX-License-Identifier: MIT
// 컴파일러 버젼을 잠궈야할 필요성이 있기 때문에
pragma solidity ^0.8.0;

// Class 대신 contract라는 이름을 쓴다.
contract FundRaising {
    // ## Variables
    uint64 public targetAmount;

    address public owner; // address는 지갑 소유자의 이더리움 지갑 주소

    mapping(address => uint256) public donations; // hash Table 생성 key => value

    uint256 public raisedAmount = 0;
    uint256 public finishTime = block.timestamp + 2 weeks; // 켐페인이 종료하는 날짜를 '초'로 표기 여기서 `block`은 미리 사전에 정의되지 않은 객체

    // `block`은 contract를 배포할때, EVM에 의해서 정의될 객체이다.

    // 이는 프로젝트 소유자가 모금하고자 하는 금액을 명시할 수 있도록 하겠다는 뜻이다. 컨트랙을 배포할 때
    // 생성자에서 아무것도 정의하지 않았지만, EVM안에서 코드가 실행될때 정의될것이다.
    // ## Constructor
    constructor(uint256 _targetAmount) {
        targetAmount = uint64(_targetAmount);
        owner = msg.sender;
        // msg는 블록 글로벌 변수이다.
    }

    // ## Method
    // `external`은 외부에서만 실행될 수 있다는 것을 알림
    // `payable`은 이 함수가 돈을 받을 수 있다는 것을 알림
    // `require`은 조건문을 거는데, 만일 False이면, ','의 뒤의 메시지를 Throw시킬거임
    receive() external payable {
        // 이부분에서 function을 빼는 이유는 이더가 컨트랙트로 직접 전송될 때 이 함수가 호출되는 특수 함수이기 때문에
        require(block.timestamp < finishTime, "This campaign is over"); // 여기서 block.timestamp란 외부에서 보낸 날짜를 의미
        donations[msg.sender] += msg.value; // Hash에 저장 `+=`을 하는 이유는 추가로 보낼수 있기 때문에
        raisedAmount += msg.value;
    }

    function withdrawDonations() external {
        require(
            msg.sender == owner,
            "Funds will only be released to the owner"
        );

        require(
            raisedAmount >= targetAmount,
            "The project did not reach the goal"
        );
        require(block.timestamp > finishTime, "The campaign is not over yet");
        payable(owner).transfer(raisedAmount); // `transfer` raisedAmount를 전달하기 위함
    }

    function refund() external {
        require(block.timestamp > finishTime, "The campaign is not over yet");
        require(raisedAmount < targetAmount, "The campaign reached the goal");
        require(
            donations[msg.sender] > 0,
            "you did not donate to this campaign"
        ); // 기부자 명단에 있는지 체크
        uint256 toRefund = donations[msg.sender];
        donations[msg.sender] = 0; // Donation 명단에서 제외
        payable(msg.sender).transfer(toRefund);
    }

    function balanceOf(address account) external view returns (uint256) {
        return donations[account];
    }
}
