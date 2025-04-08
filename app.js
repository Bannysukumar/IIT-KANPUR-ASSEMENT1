let web3;
let contract;
const contractAddress = "0xeed885509f84f03144ba9e181f6fcd2e02ce265a"; // Sepolia contract address

async function connectWallet() {
  if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    await window.ethereum.request({ method: 'eth_requestAccounts' });
    const accounts = await web3.eth.getAccounts();
    document.getElementById("walletAddress").innerText = `Connected: ${accounts[0]}`;
    contract = new web3.eth.Contract(contractABI, contractAddress);
  } else {
    alert("MetaMask not found");
  }
}

async function addDrug() {
  const name = document.getElementById("drugName").value;
  const accounts = await web3.eth.getAccounts();
  await contract.methods.addDrug(name).send({ from: accounts[0] });
  alert("Drug added successfully!");
}

async function transferDrug() {
  const id = document.getElementById("drugIdTransfer").value;
  const to = document.getElementById("toAddress").value;
  const accounts = await web3.eth.getAccounts();
  await contract.methods.transferDrug(id, to).send({ from: accounts[0] });
  alert("Drug transferred successfully!");
}

async function markDelivered() {
  const id = document.getElementById("drugIdDelivered").value;
  const accounts = await web3.eth.getAccounts();
  await contract.methods.markDelivered(id).send({ from: accounts[0] });
  alert("Drug marked as delivered!");
}

async function getDrugHistory() {
  const id = document.getElementById("drugIdHistory").value;
  const historyList = document.getElementById("historyList");
  historyList.innerHTML = "";
  const addresses = await contract.methods.getDrugHistory(id).call();
  addresses.forEach(addr => {
    const li = document.createElement("li");
    li.textContent = addr;
    historyList.appendChild(li);
  });
} 