// @APIVersion 1.0.0
// @Title beego Test API
// @Description beego has a very cool tools to autogenerate documents for your API
// @Contact astaxie@gmail.com
// @TermsOfServiceUrl http://beego.me/
// @License Apache 2.0
// @LicenseUrl http://www.apache.org/licenses/LICENSE-2.0.html
package routers

import (
	"web-trace-api/controllers"

	beego "github.com/beego/beego/v2/server/web"
)

func init() {


	beego.Router("/food", &controllers.FoodInfoController{}, "post:NewFood")
	beego.Router("/adddistribution", &controllers.FoodInfoController{}, "post:AddFoodByDistribution")
	beego.Router("/addretail", &controllers.FoodInfoController{}, "post:AddFoodByRetail")
	beego.Router("/trace", &controllers.FoodInfoController{}, "get:GetTraceByFoodId")

}
