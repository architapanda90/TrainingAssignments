pragma solidity ^0.4.20;

contract AbstractMultiSig
{
    address ownerr;
    address public beneficiary;
    mapping(address=>bool)signer;
    address[] public signers;
    uint minimumWithdraw;
    uint contributionAmt;
    uint totalContributors;
    uint i=0;
    address public contributer;
    mapping(address=>bool) complete;
    address[] public bfcry;
    address[] public cbtr;
    mapping(address=>bool)cont;
    mapping (address=>uint) proposal;
    mapping(address=>uint) contribution;
    mapping(address=>mapping(address=>bool))hasVotedNo;
    mapping(address=>address)approveYes;
    mapping(address=>uint) public yesCount;
    mapping(address=>mapping(address=>bool))hasVotedYes;
    mapping(uint=>address)no;
    mapping(address=>address)approveNo;
    mapping(address=>uint)public noCount;
    mapping(address=>bool)bf;
    mapping(address=>uint)beneficiaryIndex;
    uint public contractBalance=0;
    uint public remainingBalance=0;
    mapping(address=>bool)open;
    enum State {AcceptingContributions,Active}
    State state;
    
    constructor() public
    {
        ownerr=msg.sender;
        setSigner();
        state=State.AcceptingContributions;
    }
    
    function owner() view external returns(address)
    {
        return ownerr;
    }
    
   
    function() public payable
    {
        require(state==State.AcceptingContributions);
        require(msg.value>0);
        if(cont[msg.sender]==false)
        {
            contributer=msg.sender;
            cbtr.push(msg.sender);
            contribution[msg.sender]=msg.value;
            cont[msg.sender]=true;
        }
        else
        {
            contribution[msg.sender]=contribution[msg.sender]+msg.value;
        }
        contractBalance=contractBalance+msg.value;
      emit ReceivedContribution(msg.sender,msg.value);
    }
     event ReceivedContribution(address indexed _contributor, uint _valueInWei);
     
     
    function setSigner() public
    {
        signer[0xfA3C6a1d480A14c546F12cdBB6d1BaCBf02A1610]=true;
        signers.push(0xfA3C6a1d480A14c546F12cdBB6d1BaCBf02A1610);
        signer[0x2f47343208d8Db38A64f49d7384Ce70367FC98c0]=true;
        signers.push(0x2f47343208d8Db38A64f49d7384Ce70367FC98c0);
        signer[0x7c0e7b2418141F492653C6bF9ceD144c338Ba740]=true;
        signers.push(0x7c0e7b2418141F492653C6bF9ceD144c338Ba740);
    }
    
    function endContributionPeriod() external
    {
        state=State.Active;
        require(bf[msg.sender]==false);
        require(signer[msg.sender]==true);
        remainingBalance=contractBalance;
    }

    
    function submitProposal(uint _valueInWei) external
    {
        require(state==State.Active);
        require(state!=State.AcceptingContributions);
        require(signer[msg.sender]==false);
        require(signer[msg.sender]==false);
        require(open[msg.sender]==false);
        require(_valueInWei>0);
        beneficiary=msg.sender;
        require(contractBalance>0);
        require(remainingBalance>0);
        require(!((10*_valueInWei)>contractBalance));
        bfcry.push(beneficiary);
        beneficiaryIndex[beneficiary]=i;
        i++;
        proposal[beneficiary]=_valueInWei;
        remainingBalance=remainingBalance-_valueInWei;
        open[beneficiary]=true;
        bf[msg.sender]=true;
        complete[beneficiary]=false;
     emit ProposalSubmitted(msg.sender,_valueInWei);
    }
    event ProposalSubmitted(address indexed _beneficiary, uint _valueInWei);
    
    function listOpenBeneficiariesProposals() external view returns (address[])
    {
        return bfcry;
    }
    
    function getBeneficiaryProposal(address _beneficiary) external view returns (uint)
    {
        require(signer[_beneficiary]==false);
        require(complete[_beneficiary]==false);
        return proposal[_beneficiary];
    }
    
    function listContributors() external view returns (address[])
    {
        return cbtr;
    }
    
    function getContributorAmount(address _contributor) external view returns (uint)
    {
        return contribution[_contributor];
    }
    
    function approve(address _beneficiary) external
    {
        require(state==State.Active);
        require(state!=State.AcceptingContributions);
        require(signer[msg.sender]==true);
        require(msg.sender!=_beneficiary);
        require(signer[_beneficiary]==false);
        require(bf[msg.sender]==false);
        require(bf[_beneficiary]==true);
        require(hasVotedNo[msg.sender][_beneficiary]==false);
        require(hasVotedYes[msg.sender][_beneficiary]==false);
        require(open[_beneficiary]==true);
        approveYes[msg.sender]=_beneficiary;
        hasVotedYes[msg.sender][_beneficiary]=true;
        yesCount[_beneficiary]++;
     emit ProposalApproved(msg.sender,_beneficiary,proposal[_beneficiary]);
    }
    event ProposalApproved(address indexed _approver, address indexed _beneficiary, uint _valueInWei);
    
    function reject(address _beneficiary) external
    {
        require(state==State.Active);
        require(state!=State.AcceptingContributions);
        require(signer[msg.sender]==true);
        require(msg.sender!=_beneficiary);
        require(signer[_beneficiary]==false);
        require(bf[msg.sender]==false);
        require(bf[_beneficiary]==true);
        require(hasVotedNo[msg.sender][_beneficiary]==false);
        require(hasVotedYes[msg.sender][_beneficiary]==false);
        require(open[_beneficiary]==true);
        approveNo[msg.sender]=_beneficiary;
        hasVotedNo[msg.sender][_beneficiary]=true;
        noCount[_beneficiary]++;
     emit ProposalRejected(msg.sender,_beneficiary,proposal[_beneficiary]);
    }
    event ProposalRejected(address indexed _approver, address indexed _beneficiary, uint _valueInWei);
    
    function getSignerVote(address _signer, address _beneficiary)view external returns(uint)
    {
        require(signer[_signer]==true);
        require(bf[_beneficiary]==true);
        if(hasVotedYes[_signer][_beneficiary]==true)
        {
            return 1;
        }
        else if(hasVotedNo[_signer][_beneficiary]==true)
        {
            return 2;
        }
        else
        {
            return 0;
        }
    }

    function withdraw(uint _valueInWei) payable external
    {
        require(state==State.Active);
        require(state!=State.AcceptingContributions);
        require(bf[msg.sender]==true);
        require(yesCount[msg.sender]!=noCount[msg.sender]);
        if(yesCount[msg.sender]>noCount[msg.sender])
        {
            require(_valueInWei<=proposal[msg.sender]);
            msg.sender.transfer(_valueInWei);
            if(_valueInWei<proposal[msg.sender])
            {
                proposal[msg.sender]=proposal[msg.sender]-_valueInWei;
                remainingBalance=remainingBalance+proposal[msg.sender];
            }
            else
            {
                remainingBalance=remainingBalance-_valueInWei;
            }
        }
        else
        {
            remainingBalance=remainingBalance+proposal[msg.sender];
        }
        if((_valueInWei==proposal[msg.sender])||(noCount[msg.sender]>yesCount[msg.sender]))
        {
            bf[msg.sender]=false;
            open[msg.sender]=false;
            complete[msg.sender]=true;
            uint j=beneficiaryIndex[msg.sender];
            if(bfcry[j] == msg.sender)
            {
                if(j!=bfcry.length-1)
                {
                    beneficiaryIndex[bfcry[j+1]]=beneficiaryIndex[bfcry[j]];
                    bfcry[j]=bfcry[j+1];
                    bfcry.length--;
                }
                else
                {
                    delete(bfcry[j]);
                    bfcry.length--;
                }
            }
        }
       

      emit WithdrawPerformed(msg.sender,_valueInWei);
    }
     event WithdrawPerformed(address indexed _beneficiary, uint _valueInWei);
   }