const { time } = require("@nomicfoundation/hardhat-network-helpers");

async function main() {
    await time.increase(3600 * 24 * 14 + 1);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
