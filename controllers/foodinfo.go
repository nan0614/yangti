package controllers

import (
	"web-trace-api/models"
	"web-trace-api/service"
	"encoding/json"
    "fmt"
	"time"
	"math/big"
	beego "github.com/beego/beego/v2/server/web"
)

// Operations about object
type FoodInfoController struct {
	beego.Controller
}

type FoodDTO struct{
	TraceNumber   string  `json: "traceNumber"`
	TraceName      string  `json: "traceName"`
	Quality int64    `json: "quality"`

}

func (c *FoodInfoController) NewFood() {
	var dto FoodDTO
	json.Unmarshal(c.Ctx.Input.RequestBody, &dto)
     fmt.Println(dto)
	 producer, _, _ := service.GetUserSession(1)
	//  NewFood(traceNumber string, traceName string, quality *big.Int, timestamp string)
          currentTime := time.Now()
    currentTimeString := currentTime.Format("2006-01-02 15:04:05") // 根据需求选择时间格式
	tx, _, err:= producer.NewFood(dto.TraceNumber,dto.TraceName,big.NewInt(dto.Quality),currentTimeString)



	if err != nil {
		c.Data["json"] = map[string]string{"error": "not success"}
		
	}else{
		c.Data["json"] = map[string]string{"success": tx.Hash().Hex()}
	}
	c.ServeJSON()
}





func (c *FoodInfoController) AddFoodByDistribution() {
	var dto FoodDTO
	json.Unmarshal(c.Ctx.Input.RequestBody, &dto)
     fmt.Println(dto)
	 distribution, _, _ := service.GetUserSession(2)
	 currentTime := time.Now()
	 currentTimeString := currentTime.Format("2006-01-02 15:04:05") // 根据需求选择时间格式
	tx, _, err:= distribution.AddTraceInfoByDistributor(dto.TraceNumber,dto.TraceName,big.NewInt(dto.Quality),currentTimeString)
	

	if err != nil {
		c.Data["json"] = map[string]string{"error": "not success"}
		
	}else{
		c.Data["json"] = map[string]string{"success": tx.Hash().Hex()}
	}
	c.ServeJSON()
}


func (c *FoodInfoController) AddFoodByRetail() {
	var dto FoodDTO
	json.Unmarshal(c.Ctx.Input.RequestBody, &dto)
     fmt.Println(dto)
	 retailer, _, _ := service.GetUserSession(3)
	 currentTime := time.Now()
	 currentTimeString := currentTime.Format("2006-01-02 15:04:05") // 根据需求选择时间格式
	tx, _, err:= retailer.AddTraceInfoByRetailer(dto.TraceNumber,dto.TraceName,big.NewInt(dto.Quality),currentTimeString)
	

	if err != nil {
		c.Data["json"] = map[string]string{"error": "not success"}
		
	}else{
		c.Data["json"] = map[string]string{"success": tx.Hash().Hex()}
	}
	c.ServeJSON()
}

func (c *FoodInfoController) GetTraceByFoodId() {
	traceNumber := c.GetString("traceNumber")
	fmt.Println(traceNumber)
	traceNameList,qualityList, statusList,timestampList,err:= service.BlockSession.GetTraceInfoByTraceNumber(traceNumber)
	// GetTraceInfoByTraceNumber(traceNumber string) ([]string, []*big.Int, []*big.Int, []string, error)


	if err != nil {
		c.Data["json"] = map[string]string{"error": "not success"}
		c.ServeJSON()
		return
	}
	var foodInfoList []models.FoodInfo
	for i := 0; i < len(traceNameList); i++ {
		var foodInfo models.FoodInfo
		foodInfo.TraceName = traceNameList[i]
		foodInfo.Quality = qualityList[i].Int64()
		foodInfo.Status = statusList[i].Int64()
		foodInfo.Timestamp = timestampList[i]

		foodInfoList = append(foodInfoList, foodInfo)
	}

	fmt.Println(foodInfoList)
	c.Data["json"] =map[string][]models.FoodInfo{"data": foodInfoList}
	c.ServeJSON()

}

