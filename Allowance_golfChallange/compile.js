const path=require ('path'); 

const fs=require ('fs');

const solc=require ('solc');

const AllowancePath=path.resolve(__dirname,'contracts','Allowance.sol');

const source=fs.readFileSync(AllowancePath,'utf8');

console.log(solc.compile(source,1));

module.exports=solc.compile(source,1).contracts[':Allowance'];
