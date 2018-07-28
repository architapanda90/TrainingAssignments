const HDWalletProvider=require('truffle-hdwallet-provider');
const Web3=require('web3');
const {interface,bytecode}=require ('./compile');
const provider=new HDWalletProvider('abuse elite bean to vintage twelve pass  fail friend federal usual water hobby mom',
'https://rinkeby.infura.io/ydgfhdyvuzzKZ2KA4UpbceqJ');
const web3=new Web3(provider);


const deploy= async ()=>{
				const accounts=await web3.eth.getAccounts();
				console.log('The contract is deployed from ',accounts[0]);
		const result= await new web3.eth.Contract(JSON.parse(interface))
							.deploy({data:bytecode})
							.send({gas: '1000000',from: accounts[0]});
			console.log('contract has been deployed to ',result.options.address);
		};
deploy();
