//
//  HMDataRequestURL.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/4/20.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#ifndef HuaxiaMerchant_HMDataRequestURL_h
#define HuaxiaMerchant_HMDataRequestURL_h


#pragma mark - 上传图片

//上传图片 is_make_thumbnail thumbnail_width thumbnail_heigth
#define Server_upload_image        [uploadImageUrl stringByAppendingString:@"/v2.0/uploadImage"]



#pragma mark - 首页

//店铺内容单元列表
#define Server_home_shop_list        [NSString stringWithFormat:@"%@/unit/list",baseUrl]

//店铺内容单元列表
#define Server_home_homeBanner        [NSString stringWithFormat:@"%@/banner/v2.0/homeBanner",baseUrl]





#pragma mark - 购物车 && 支付

//加入购物车
#define Server_shopcart_add      [NSString stringWithFormat:@"%@/shoppingCart/add",baseUrl]

//删除购物车商品
#define Server_shopcart_delete      [NSString stringWithFormat:@"%@/shoppingCart/delete",baseUrl]

//购物车商品列表
#define Server_shopcart_list      [NSString stringWithFormat:@"%@/shoppingCart/list/",baseUrl]

//编辑购物车商品
#define Server_shopcart_update      [NSString stringWithFormat:@"%@/shoppingCart/update",baseUrl]

//微信支付回调接口
#define Server_PayOnline_wecaht      [NSString stringWithFormat:@"%@/payCallback/wxpay/v1.0/order_pay_notify",baseUrl]

//支付宝支付回调接口
#define Server_PayOnline_alipay      [NSString stringWithFormat:@"%@/payCallback/alipay/v1.0/order_pay_notify",baseUrl]





#pragma mark - 订单

//用户各订单状态数量
#define Server_order_userOrderNumbers      [NSString stringWithFormat:@"%@/order/userOrderNumbers",baseUrl]

//订单列表
#define Server_order_list      [NSString stringWithFormat:@"%@/order/list",baseUrl]

//用户订单支付状态
#define Server_order_payInfo      [NSString stringWithFormat:@"%@/order/orderPayInfo",baseUrl]

//用户订单预约送货时间
#define Server_order_appointmentDeliveryTime      [NSString stringWithFormat:@"%@/order/appointmentDeliveryTime",baseUrl]

//订单取消
#define Server_order_cancel      [NSString stringWithFormat:@"%@/order/cancel",baseUrl]

//订单支付
#define Server_order_pay      [NSString stringWithFormat:@"%@/order/pay",baseUrl]

//订订单物流
#define Server_order_logistics      [NSString stringWithFormat:@"%@/order/logistics",baseUrl]

//提交订单
#define Server_order_submit      [NSString stringWithFormat:@"%@/order/submit",baseUrl]

//用户申请售后
#define Server_order_afterSalesApplication      [NSString stringWithFormat:@"%@/order/afterSalesApplication",baseUrl]

//确认签收
#define Server_order_confirmReceipt      [NSString stringWithFormat:@"%@/order/confirmReceipt",baseUrl]

//订单详情
#define Server_order_orderDetail       [NSString stringWithFormat:@"%@/order/orderDetail",merchantUrl]


#pragma mark - 店铺

//店铺详情
#define Server_shop_detail          [NSString stringWithFormat:@"%@/shop/detail",baseUrl]

//系列详情
#define Server_series_detail          [NSString stringWithFormat:@"%@/series/detail",baseUrl]



#pragma mark - 登录

//获取验证码
#define Server_login_getCaptcha      [NSString stringWithFormat:@"%@/user/getCaptcha",baseUrl]

//用户登录
#define Server_login_login           [NSString stringWithFormat:@"%@/user/login",baseUrl]

//用户个人中心
#define Server_login_personalCenter   [NSString stringWithFormat:@"%@/user/personalCenter",baseUrl]

//获取用户协议
#define Server_login_userProtocol      [NSString stringWithFormat:@"%@/user/userProtocol",baseUrl]

//返现列表
#define Server_personal_cashBackList      [NSString stringWithFormat:@"%@/personal/cashBackList",baseUrl]

//返现账号登记
#define Server_personal_withDrawCashAccount      [NSString stringWithFormat:@"%@/personal/withDrawCashAccount",baseUrl]




#pragma mark - 收货地址

//地址列表
#define Server_address_list          [NSString stringWithFormat:@"%@/address/list",baseUrl]

//新增
#define Server_address_add           [NSString stringWithFormat:@"%@/address/add",baseUrl]

//删除
#define Server_address_del           [NSString stringWithFormat:@"%@/address/delete",baseUrl]

//修改
#define Server_address_update        [NSString stringWithFormat:@"%@/address/update",baseUrl]

//开通城市地址配置
#define Server_address_serverOpened  [NSString stringWithFormat:@"%@/config/region/serverOpened",baseUrl]

//省市区集合
#define Server_config_getRegionList       [NSString stringWithFormat:@"%@/data/getRegionList",merchantUrl]




#pragma mark - 店铺&商品

//商品详情
#define Server_goods_detail        [NSString stringWithFormat:@"%@/goods/detail/",baseUrl]

//商品规格及价格
#define Server_goods_sku        [NSString stringWithFormat:@"%@/goods/sku/",baseUrl]







#endif
