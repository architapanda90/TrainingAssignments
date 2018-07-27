import "../stylesheets/app.css";
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

import registryArtifacts from '../../build/contracts/SimpleRegistry.json'
var SimpleRegistry = contract(registryArtifacts);

import { Connect,SimpleSigner } from 'uport-connect'

      const uport = new Connect('Archita \'s new app', {
      clientId: '2ozsFYA9Z7j4jj42jwNLuHXqwV3Lkv79emB',
      network: 'rinkeby',
      signer: SimpleSigner('a80bb0ca8d968c203e6a3c29861bf03e3fa4d37ed319d5dca7ea281df69cd502')
    })

const web3 = uport.getWeb3();

var account;

window.App = {
  start: function() {
    var self = this;
    SimpleRegistry.setProvider(web3.currentProvider);

    web3.eth.getAccounts(function(err, accounts) {

      if (typeof accounts[0] == 'undefined') {
        alert("MetaMask is locked. Unlock it by entering your password and refresh this page");
        return;
      }
      account = accounts[0];
      self.refreshGet();
    });
  },

  refreshGet: function() {
    var self = this;

    SimpleRegistry.deployed().then(function(instance) {
      return instance.get.call('test');
    }).then(function(value) {
      var getResult = document.getElementById("getResult");
      getResult.innerHTML = value.valueOf();
    }).catch(function(e) {
      console.log(e);
    });
  },

  setNewValue: function() {
    var self = this;

    var newValue = parseInt(document.getElementById("newValue").value);

    SimpleRegistry.deployed().then(function(instance) {
      return instance.register('test', newValue, {from: account});
    })
    .then(function(result) {
      // result.tx = tx hash
      // result.receipt
      // result.logs
      console.log(result);
      for (var i = 0; i < result.logs.length; i++) {
        var log = result.logs[i];
        if (log.event == "NewValueRegistered") {
          console.log('Found NewValueSet', result.logs[i]);
        }
      }
    }).catch(function(e) {
      console.log(e);
    });
  }
};

window.addEventListener('load', function() {
  if (typeof web3 !== 'undefined') {
    window.web3 = new Web3(web3.currentProvider);
  } else {
    alert('MetaMask is not installed!');
  }
  App.start();
});
