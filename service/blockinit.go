package service

import (
	"fmt"
	"log"
    "web-trace-api/trace"

	"github.com/FISCO-BCOS/go-sdk/client"
	"github.com/FISCO-BCOS/go-sdk/conf"
	"github.com/beego/beego/v2/server/web"
	"github.com/ethereum/go-ethereum/common"
)



// init block
var BlockSession *foodinfo.FoodInfoSession


func init() {
	configs, err := conf.ParseConfigFile("./trace/config.toml")
	if err != nil {
		log.Fatal("出错，配置文件读取不出来", err)
	}

	config := configs[0]

	fmt.Println("成功读取配置文件")

	c, err := client.Dial(&config)
	if err != nil {
		
		log.Fatal("出错，客户端生成失败", err)
	}

	address, err := web.AppConfig.String("contractAddress")
	if err != nil {
		log.Fatal("出错配置的合约地址读取不出来")
	}
	contractAddress := common.HexToAddress(address)
	instance, err := foodinfo.NewFoodInfo(contractAddress, c)
	if err != nil {
		log.Fatal("出错 block连接失败", err)
	}

	BlockSession = &foodinfo.FoodInfoSession{Contract: instance, CallOpts: *c.GetCallOpts(), TransactOpts: *c.GetTransactOpts()}
	log.Println("成功初始化合约配置")
}

func GetUserSession(roleId int) (*foodinfo.FoodInfoSession, bool, error) {
	configs, err := conf.ParseConfigFile("./trace/config.toml")
	if err != nil {
		return nil, false, err
	}

	config := configs[0]


	 var pemName  =""
	if roleId == 1{
		 pemName = "producer_key_0x82a25c9a26cda8600820309dd90b425946a0003b"
	}else if roleId == 2{
	     pemName = "distributor_key_0x8a52a9ca9511c1c926a89753430b6a0126652e76"
	}else if roleId == 3{
	   pemName = "retailer_key_0x172518bfcf5887e1c427debeb897d8304d63caee"
	}

	keyBytes, curve, err := conf.LoadECPrivateKeyFromPEM("./trace/accounts/"+pemName+".pem")
	 

	if err != nil {
		return nil, false, err
	}
	if config.IsSMCrypto && curve != "sm2p256v1" {
		return nil, false, err
	}

	if !config.IsSMCrypto && curve != "secp256k1" {
		return nil, false, err
	}
	config.PrivateKey = keyBytes
	c, err := client.Dial(&config)
	if err != nil {
		return nil, false, err
	}

	address, err := web.AppConfig.String("contractAddress")
	if err != nil {
		return nil, false, err
	}
	contractAddress := common.HexToAddress(address)
	instance, err := foodinfo.NewFoodInfo(contractAddress, c)
	if err != nil {
		return nil, false, err
	}

	userSession := &foodinfo.FoodInfoSession{Contract: instance, CallOpts: *c.GetCallOpts(), TransactOpts: *c.GetTransactOpts()}
	return userSession, true, nil
}
