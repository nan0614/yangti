pragma solidity ^0.4.25;
import "./RoleStorage.sol";

contract RoleController{
    
    
    RoleStorage private roleStorage;
    
    
    
    
    // 生产者的roleid是1
      int256 constant PR_ID = 1;
    // 中间商的roleid   是2
    int256 constant DR_ID = 2;
    // 零售商的roleid是3
    int256 constant RR_ID = 3;
    
    constructor(address producer,address distribution,address retailer) public {
        roleStorage = new RoleStorage();
        roleStorage.addRole(producer,PR_ID);
         roleStorage.addRole(distribution,DR_ID);
         roleStorage.addRole(retailer,RR_ID);

        
    }
    
    
    
    modifier onlyProducer() {
        
       require(roleStorage.isExist(msg.sender,PR_ID),"you are not producer");
       
       _;
        
    }
        modifier onlyDistribution() {
        
       require(roleStorage.isExist(msg.sender,DR_ID),"you are not distribution");
       
       _;
        
    }
        modifier onlyRetailer() {
        
       require(roleStorage.isExist(msg.sender,RR_ID),"you are not retailer");
       
       _;
        
    }
    
    function setPRRole(address amount) public returns (int){
        require(roleStorage.isExist(msg.sender,PR_ID),"you are not producer");
        
       return   roleStorage.addRole(amount,PR_ID);
        
    }
    
    function resetPRRole() public returns(int){
     
        require(roleStorage.isExist(msg.sender,PR_ID),"you are not producer");
        
        
        return roleStorage.removeRole(msg.sender,PR_ID);
        
        
    }
    
    
     function setDRRole(address amount) public returns (int){
        require(roleStorage.isExist(msg.sender,DR_ID),"you are not distribution");
        
       return   roleStorage.addRole(amount,DR_ID);
        
    }
    
    function resetDRRole() public returns(int){
  
        require(roleStorage.isExist(msg.sender,DR_ID),"you are not distribution");
        return roleStorage.removeRole(msg.sender,DR_ID);
    }
    
    
    
     function setRRRole(address amount) public returns (int){
        require(roleStorage.isExist(msg.sender,RR_ID),"you are not distribution");
        
       return   roleStorage.addRole(amount,RR_ID);
        
    }
    
    function resetRRRole() public returns(int){
      
        require(roleStorage.isExist(msg.sender,RR_ID),"you are not retailer");
        return roleStorage.removeRole(msg.sender,RR_ID);
    }
    
    
    
    
    
    
    
}
    