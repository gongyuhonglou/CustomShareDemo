//
//  RPShareItemView.h
//  ShareDemo
//
//  Created by rpweng on 2019/5/10.
//  Copyright © 2019 rpweng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
// 界面宽高
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM(NSUInteger, ShareType) {
    WeChatFriend = 0,
    WeChatCircle,
    QQFriend,
    QQZone,
    WeiBo
};


@interface RPShareView : UIView
- (void)showFromControlle:(UIViewController *)controller;
- (void)setShareContentWithData:(id)data;
/**
 @param url 分享内容的目标URL
 @param title 分享内容的标题
 @param description 分享内容的描述
 @param thumbImage 分享内容的预览图像
 */
- (void)shareWithURL:(NSString *)url title:(NSString *)title description:(NSString *)description thumbImage:(UIImage *)thumbImage;

@end
@interface RPShareItemView : UIView
@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *btnActionKey;
@property (nonatomic, copy) void(^returnShareActionKey)(NSString *actionKey);
@end
@interface RPShareButton: UIButton

@property (nonatomic, strong) NSString *actionKey;

@end

NS_ASSUME_NONNULL_END
