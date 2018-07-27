const path=require ('path'); 

const fs=require ('fs');

const solc=require ('solc');

const AbstractMultiSigPath=path.resolve(__dirname,'contracts','AbstractMultiSig.sol');

const source=fs.readFileSync(AbstractMultiSigPath,'utf8');

//console.log(solc.compile(source,1));

module.exports=solc.compile(source,1).contracts[':AbstractMultiSig'];
