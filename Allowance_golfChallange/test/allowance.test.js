const assert=require('assert');
const ganache=require('ganache-cli');
const Web3=require('web3');
const provider=ganache.provider();
const web3=new Web3(provider);
const {interface,bytecode}=require('../compile');

let accounts;
let allowance;

beforeEach(async () =>{
			accounts= await web3.eth.getAccounts();
			
			allowance=await new web3.eth.Contract(JSON.parse(interface)).
					deploy({data:bytecode}).send({from:accounts[0],gas:'1000000'});
			});

describe('Allowance Test' , async ()=>{
					this.timeout(15000);
					it('Deploys a contract' , ()=>{
										assert.ok(allowance.options.address);
										});

					/*it('Allows entry of one player', async ()=>{
										await lottery.methods.Enter().send({from:accounts[0],value:web3.utils.toWei('0.02','ether')});
										const player=await lottery.methods.getPlayers().call({from:accounts[0]});
										assert.equal(accounts[0],player[0]);
										assert.equal(1,player.length);
					});*/

		
					it('Manager can only disberse', async ()=>{
									try{
										await allowance.methods.disburse(account[2]).send({from:accounts[1]});	
										assert(false);
									   }
									catch(err){assert(err);}
					});
										

					it('returns block number', async(done)=>{
								
									for (let i = 0; i < 10; i++)
										 {
        									console.log(await allowance.methods.see().block.number);
  										 }
										});
});