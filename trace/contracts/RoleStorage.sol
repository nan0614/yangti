pragma solidity ^0.4.25;
import "./Table.sol";
import "./Ownable.sol";

contract RoleStorage is Ownable{
    
    
     TableFactory tf;
     event Result(int count);
     
     
     string constant TABLE_NAME = "tx_role5";
     constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "account", "role_id");
    }
    
    
    function addRole(address account, int256 role ) public onlyOwner  returns(int) {
        int count = int(0);
        Table table = tf.openTable(TABLE_NAME);
        if(account != address(0) && !_isExist(table,account,role)){
            Entry entry = table.newEntry();
            entry.set("role_id", role);
            count = table.insert(addressToString(account), entry);
        }
        emit Result(count);
        return count;
    }
    
    
     function removeRole(address account,int256 role) public onlyOwner returns(int) {
        int count = int(0);
        Table table = tf.openTable(TABLE_NAME);      
        if(_isExist(table,account,role)){
  
        Condition condition = table.newCondition();
          condition.EQ("role_id",role);
        count = table.remove(addressToString(account),condition);         
        }
     
        emit Result(count);
        return count;        
    }
    
    
    function checkRole(address account) public onlyOwner view returns(int256[]){
        Table table = tf.openTable(TABLE_NAME);
        Condition condition = table.newCondition();
        Entries entries = table.select(addressToString(account), condition);
        int256[] memory role_id_list = new int256[](uint256(entries.size()));
        for (int256 i = 0; i < entries.size(); ++i) {
            Entry entry = entries.get(i);
            role_id_list[uint256(i)] = entry.getInt("role_id");
        }
        return role_id_list;

    }
    
    
    function _isExist(Table _table, address  account, int256 role) internal view returns(bool) {
        Condition condition = _table.newCondition();
        condition.EQ("role_id", role);
        return _table.select(addressToString(account), condition).size() > int(0);
    }
    
    
    
    function isExist( address  account, int256 role) public onlyOwner view returns(bool) {
      Table table = tf.openTable(TABLE_NAME);
        return _isExist(table,account,role) ;
    }
    
    
    
    
    
    function addressToString(address _address) private pure returns (string memory _uintAsString) {
      uint _i = uint256(_address);
      if (_i == 0) {
          return "0";
      }
      uint j = _i;
      uint len;
      while (j != 0) {
          len++;
          j /= 10;
      }
      bytes memory bstr = new bytes(len);
      uint k = len - 1;
      while (_i != 0) {
          bstr[k--] = byte(uint8(48 + _i % 10));
          _i /= 10;
      }
      return string(bstr);
    }
    
    
}