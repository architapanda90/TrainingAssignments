const path=require ('path'); 

const fs=require ('fs');

const solc=require ('solc');

const QuoteRegistryPath=path.resolve(__dirname,'contracts',QuoteRegistry.sol');

const source=fs.readFileSync(QuoteRegistryPath,'utf8');

console.log(solc.compile(source,1));

module.exports=solc.compile(source,1).contracts[':QuoteRegistry'];
