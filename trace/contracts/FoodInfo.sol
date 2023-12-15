pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
import "./RoleController.sol";
import "./FoodTraceDetail.sol";

contract FoodInfo is RoleController{
    
    
  FoodTraceDetail private foodTraceDetail;
 
 
 
   constructor (address producer,address distribution,address retailer) public RoleController(producer,distribution,retailer){
       
       foodTraceDetail = new FoodTraceDetail();
   }
   
   
   
   
   function newFood(string traceNumber,string traceName,int quality ,string timestamp) public onlyProducer {
       
       foodTraceDetail.newFoodDetail(traceNumber,traceName,quality,timestamp);
       
   }
   
      
   function addTraceInfoByDistributor(string traceNumber,string traceName,int quality ,string timestamp) public onlyDistribution {
       
       foodTraceDetail.addTraceInfoByDistributor(traceNumber,traceName,quality,timestamp);
       
   }
   
   function addTraceInfoByRetailer(string traceNumber,string traceName,int quality,string timestamp) public onlyRetailer{
       foodTraceDetail.addTraceInfoByRetailer(traceName,traceName,quality,timestamp);
   }
   
   
   function getTraceInfoByTraceNumber(string traceNumber) public view returns(string[],int256[],int256[],string[]){
       
       return foodTraceDetail.getTraceInfoByTraceNumber(traceNumber);
   }
   
    
}