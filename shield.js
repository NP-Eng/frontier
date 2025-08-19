const { ethers } = require("ethers");

async function main() {
  // Frontier node RPC endpoint
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:9944");

  // Your private key for 0x3Cd0A705a2DC65e5b1E1205896BaA2be8A07c6e0
  const PRIVATE_KEY = "0x8075991ce870b93a8870eca0c0f91913d12f47948ca0fd25b49c6fa7cdbeee8b";

  // Create wallet instance
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  console.log("Sending from:", wallet.address);

  // Zero address
  const zeroAddress = "0x0000000000000000000000000000000000000000";

  // Send 1 ETH to zero address
  const tx = await wallet.sendTransaction({
    to: zeroAddress,
    value: ethers.parseEther("1.0"), // 1 ETH
    gasLimit: 21000 // standard ETH transfer gas
  });

  console.log("Transaction hash:", tx.hash);

  // Wait for transaction confirmation
  const receipt = await tx.wait();
  console.log("Transaction confirmed in block:", receipt.blockNumber);
}

main().catch(console.error);

