import { task } from "hardhat/config";
import { writeFile, readFile } from "fs/promises";

task("deploy", "Deploy Horizons", async (_, hre) => {
  console.log("Deploy contract Horizons");
  const factory = await hre.ethers.getContractFactory("Horizons");

  const contract = await factory.deploy();
  console.log("  Address", contract.address);
  const receipt = await contract.deployed();
  console.log("  Receipt", receipt.deployTransaction.hash);

  const { chainId } = await hre.ethers.provider.getNetwork();

  const config = {
    Horizons: contract.address,
  };

  console.log("Configuration file in ./artifacts/network.json");
  await writeFile(
    `./artifacts/network-${chainId}.json`,
    JSON.stringify(config, null, 2)
  );
});
