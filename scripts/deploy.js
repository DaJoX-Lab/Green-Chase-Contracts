async function main() {
    const Greenchase = await hre.ethers.getContractFactory("Greenchase");
    const greenchase = await Greenchase.deploy();
  
    await greenchase.deployed();
  
    console.log("Greenchase deployed to:", greenchase.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });