// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*' // Match any network id
    }
 
	rinkeby: {
	provider:()=>{ return new WalletProvider(wallet,'https://rinkeby.infura.io")}
	gas :"4600000",
	network_id:"*"
	}
}
}
