import { ethers } from "hardhat";
import chai from "chai";
import { readdir, readFile, writeFile } from "fs/promises";
import chaiAsPromised from "chai-as-promised";
import { solidity } from "ethereum-waffle";
import { Horizons__factory, Horizons } from "../typechain";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import path from "path";

const SVGS_PATH = path.join(__dirname, "..", "svg");

chai.use(solidity);
chai.use(chaiAsPromised);
const { expect } = chai;

const AddressZero = ethers.constants.AddressZero;
const AddressOne = AddressZero.replace(/.$/, "1");

function base64Decode(data: string) {
  return Buffer.from(data, "base64").toString("utf8");
}

describe("Horizons smart contract", () => {
  let horizons: Horizons;
  let alice: SignerWithAddress, bob: SignerWithAddress;
  let aliceH: Horizons, bobH: Horizons;

  beforeEach(async () => {
    [alice, bob] = await ethers.getSigners();

    const HorizonsFactory = (await ethers.getContractFactory(
      "Horizons",
      alice
    )) as Horizons__factory;
    horizons = await HorizonsFactory.deploy();
    await horizons.deployed();

    aliceH = horizons.connect(alice);
    bobH = horizons.connect(bob);
  });

  it("generates all 81 SVGs", async () => {
    const filenames = await readdir(SVGS_PATH);
    for (let filename of filenames) {
      const tokenId = parseInt(filename.split(".")[0].split("-")[1]);
      console.log("Test tokenId", tokenId);
      const originalSVG = await readFile(
        path.join(SVGS_PATH, filename),
        "utf8"
      );

      // Note: colors are inverted in the generated SVG.
      const match1 = originalSVG.match(/cls-2{fill:#(......)/);
      const match2 = originalSVG.match(/cls-1{fill:#(......)/);
      let originalColor1 = match1 ? match1[1] : "000000";
      let originalColor2 = match2 ? match2[1] : "000000";

      // Some artworks have only one color. In that case `cls-1` applies to the
      // second rect of the SVG, that's why colors are swapped here.
      if ([35, 41, 54, 66].includes(tokenId)) {
        const c1 = originalColor1;
        originalColor1 = originalColor2;
        originalColor2 = c1;
      }

      const generatedSVG = base64Decode(await horizons.getSVG(tokenId));

      const matches = generatedSVG.matchAll(/fill="#(......)"/g);
      const generatedColor1 = matches.next().value[1];
      const generatedColor2 = matches.next().value[1];

      expect(originalColor1).to.equal(generatedColor1);
      expect(originalColor2).to.equal(generatedColor2);
      /*
      const outfile = path.join(
        __dirname,
        "..",
        "generated-svg",
        tokenId + ".svg"
      );
      await writeFile(outfile, JSON.parse(`"${generatedSVG}"`));
      */
    }
  });

  it("Allows the owner to mint tokens up to MAX_SUPPLY", async () => {
    await aliceH.safeMintAll(alice.address, 1, 10);
    await expect(bobH.safeMintAll(bob.address, 11, 11)).to.revertedWith(
      "Ownable: caller is not the owner"
    );
    await aliceH.safeMintAll(alice.address, 11, 81);
    await expect(aliceH.safeMintAll(alice.address, 0, 0)).to.revertedWith(
      "Horizons: invalid tokenId"
    );
    await expect(aliceH.safeMintAll(alice.address, 82, 100)).to.revertedWith(
      "Horizons: supply exceeded"
    );
  });

  it("Returns a valid JSON file", async () => {
    await aliceH.safeMintAll(alice.address, 1, 1);
    const data = await horizons.tokenURI(1);
    const splitIndex = data.indexOf(",");
    const [mediaType, rawJson] = [
      data.slice(0, splitIndex),
      data.slice(splitIndex + 1),
    ];
    const json = JSON.parse(base64Decode(rawJson));
    expect(json.name).to.equal("Horizon 1");
    expect(json.description).to.equal(
      "81 Horizons is a collection of 81 on-chain landscapes.\n" +
        "Each work consists of a unique combination of " +
        "two colored rectangles.\n" +
        "Rafaël Rozendaal, 2021\n" +
        "License: CC BY-NC-ND 4.0"
    );
    const svg = await horizons.getSVG(1);
    const image = "data:image/svg+xml;base64," + svg;
    expect(json.image).to.equal(image);
  });
});
