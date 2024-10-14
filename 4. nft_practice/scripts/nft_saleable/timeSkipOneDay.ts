import { time } from "@nomicfoundation/hardhat-network-helpers";

async function main() {
  // 시간 증가: 1일
  await time.increase(3600 * 24);

  const currentTime = await time.latest();

  const currentDate = new Date(currentTime * 1000);

  // 시간 정보 출력
  console.log(
    `${
      currentDate.getUTCDate() - 1
    }일 ${currentDate.getUTCHours()}시 ${currentDate.getUTCMinutes()}분 `
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
