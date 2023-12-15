pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
import "./Table.sol";
import "./Ownable.sol";

contract FoodTraceDetail is Ownable{
    
     
     TableFactory tf;
     event Result(int count);
     
    
    // 1 生产 2 中间 3 零售
      string constant TABLE_NAME = "tx_foodinfo5";
     constructor() public {
        tf = TableFactory(0x1001);
        tf.createTable(TABLE_NAME, "trace_number", "trace_name,quality,status,timestamp");
    }
    
    
    
      function newFoodDetail(string trace_number, string trace_name ,int quality,string timestamp) public onlyOwner  returns(int) {
        int count = int(0);
        Table table = tf.openTable(TABLE_NAME);
        if( !_isExist(table,trace_number)){
            Entry entry = table.newEntry();
            entry.set("trace_name", trace_name);
            entry.set("quality", quality);
            entry.set("status", int256(1));
            entry.set("timestamp", timestamp);
            
            count = table.insert(trace_number, entry);
        }
        emit Result(count);
        return count;
    }
    
        
      function addTraceInfoByDistributor(string trace_number, string trace_name ,int quality,string timestamp) public onlyOwner  returns(int) {
        int count = int(0);
        Table table = tf.openTable(TABLE_NAME);
        if( _isExist(table,trace_number,1)){
            Entry entry = table.newEntry();
            entry.set("trace_name", trace_name);
            entry.set("quality", quality);
            entry.set("status", int256(2));
            entry.set("timestamp", timestamp);
            
            count = table.insert(trace_number, entry);
        }
        emit Result(count);
        return count;
    }
    
   function addTraceInfoByRetailer(string trace_number, string trace_name ,int quality,string timestamp) public onlyOwner  returns(int) {
        int count = int(0);
        Table table = tf.openTable(TABLE_NAME);
        if( _isExist(table,trace_number,2)){
            Entry entry = table.newEntry();
            entry.set("trace_name", trace_name);
            entry.set("quality", quality);
            entry.set("status", int256(3));
            entry.set("timestamp", timestamp);
            
            count = table.insert(trace_number, entry);
        }
        emit Result(count);
        return count;
    }
    
    

    
    function getTraceInfoByTraceNumber(string trace_number) public onlyOwner view returns(string[],int256[],int256[],string[]){
        Table table = tf.openTable(TABLE_NAME);
        Condition condition = table.newCondition();
        Entries entries = table.select(trace_number, condition);
        int256[] memory quality_list = new int256[](uint256(entries.size()));
        int256[] memory status_list = new int256[](uint256(entries.size()));
        string[] memory trace_name_list = new string[](uint256(entries.size()));
        string[] memory timestamp_list = new string[](uint256(entries.size()));
        for (int256 i = 0; i < entries.size(); ++i) {
            Entry entry = entries.get(i);
            quality_list[uint256(i)] = entry.getInt("quality");
            status_list[uint256(i)] = entry.getInt("status");
            trace_name_list[uint256(i)] = entry.getString("trace_name");
            timestamp_list[uint256(i)] = entry.getString("timestamp");
        }
        return (trace_name_list,quality_list,status_list,timestamp_list);

    }
    
    
    function _isExist(Table _table,string  trace_number, int status) private view returns(bool) {
        Condition condition = _table.newCondition();
        condition.EQ("status", status);
        return _table.select(trace_number, condition).size() > int(0);
    }
    
        function _isExist(Table _table,string  trace_number) private view returns(bool) {
        Condition condition = _table.newCondition();
        
        return _table.select(trace_number, condition).size() > int(0);
    }
    
    
    
    function isExist(string  trace_number, int status) public onlyOwner view returns(bool) {
      Table table = tf.openTable(TABLE_NAME);
        return _isExist(table,trace_number,status) ;
    }
    
    
    
}