
//
//  ViewController.m
//  WeiXinPayDemo
//
//  Created by tomandhua on 16/5/17.
//  Copyright © 2016年 tomandhua. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.viewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds)*2;
    self.secondViewLeading.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
}

- (IBAction)weixinPayAction:(id)sender {
    
//    [self xmlPost];
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
//                return @"";
            }else{
                NSLog(@"%@",[dict objectForKey:@"retmsg"]);            }
        }else{
            NSLog(@"服务器返回错误，未获取到json对象");
        }
    }else{
        NSLog(@"服务器返回错误");
//        return @"服务器返回错误";
    }
}

//- (void)xmlPost {
//    NSDictionary *unifiedPrderParams = @{@"appid":@"wxd440283f1c6abe14",
//                                         @"mch_id":@"",
//                                         @"nonce_str":@"5K8264ILTKCH16CQ2502SI8ZNMTM88VS",
//                                         @"body":@"car",
//                                         @"out_trade_no":@"20160518101122",
//                                         @"total_fee":@"0.01",
//                                         @"spbill_create_ip":@"192.168.0.11",
//                                         @"notify_url":@"",
//                                         @"trade_type":@"APP",
//                                         };
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
