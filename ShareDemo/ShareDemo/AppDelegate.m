//
//  AppDelegate.m
//  ShareDemo
//
//  Created by rpweng on 2019/5/10.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WXApiManager.h"


@interface AppDelegate ()<TencentSessionDelegate,WXApiDelegate>

/** QQ分享*/
@property(nonatomic, strong) TencentOAuth * tencentOAuth;

/** 许可*/
@property(nonatomic, strong) NSArray * permissions;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //QQ
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppId andDelegate:self];
    //weixin
    [WXApi registerApp:WX_APPID withDescription:@"wechat"];
    
    
    return YES;
}

//回到App时该回调有走
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0) // no equiv. notification. return NO if the application can't open for some reason
{
    if([url.host isEqualToString:@"platformId=wechat"]) {
        //微信分享
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.host isEqualToString:@"response_from_qq"]) {
        //QQ分享
        [TencentApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

//上面这个方法针对IOS9以上，但是对于IOS8的系统来说， 要实现下边的方法：
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if([url.host isEqualToString:@"platformId=wechat"]) {
        //微信分享
        return [WXApi handleOpenURL:url delegate:self];
    } else if ([url.host isEqualToString:@"response_from_qq"]) {
        //QQ分享
        [TencentApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}



////回到App时该回调有走
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//
//    BOOL result = YES;
//    NSString *urlStr = url.host;
//    //[url absoluteString];
//    if([urlStr isEqualToString:@"platformId=wechat"]||[urlStr isEqualToString:@"response_from_qq"]){
//        result = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    }else if([urlStr isEqualToString:@"oauth"]||[urlStr isEqualToString:@"qzapp"]){
//        result = [TencentOAuth HandleOpenURL:url];;
//    }else{
//        result = FALSE;
//    }
//
//    return YES;
//}

#pragma mark ------- 打开app的相关方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    // qq
    if (YES == [TencentApiInterface canOpenURL:url delegate:self])
    {
        [TencentApiInterface handleOpenURL:url delegate:self];
    }
    // weixin
    if (YES == [WXApi openWXApp]) {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return NO;
}

/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    NSLog(@"resp %d",resp.errCode);
    //Wechat分享返回
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) { //微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
        }
    }
    
    //QQ分享返回
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {

        SendMessageToQQResp * tmpResp = (SendMessageToQQResp *)resp;

        if (tmpResp.type == ESENDMESSAGETOQQRESPTYPE && [tmpResp.result integerValue] == 0) {
            //分享成功
        }
        else{
            //分享失败
        }
    
    }
}


//登录功能没添加，但调用TencentOAuth相关方法进行分享必须添加<TencentSessionDelegate>，则以下方法必须实现，尽管并不需要实际使用它们
//登录成功
- (void)tencentDidLogin
{
    //    _labelTitle.text = @"登录完成";
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        //        _labelAccessToken.text = _tencentOAuth.accessToken;
    }
    else
    {
        //        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
}


//非网络错误导致登录失败
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        //        _labelTitle.text = @"用户取消登录";
    }
    else
    {
        //        _labelTitle.text = @"登录失败";
    }
}

//网络错误导致登录失败
-(void)tencentDidNotNetWork
{
    //    _labelTitle.text=@"无网络连接，请设置网络";
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
