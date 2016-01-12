//
//  DCWebImageManager.h
//  DCWebPicScrollView
//
//  Created by dengchen on 15/12/7.
//  Copyright © 2015年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCWebImageManager : NSObject



//只需要设置这2个就行了

//下载失败重复下载次数,默认不重复,
@property NSUInteger DownloadImageRepeatCount;

//图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
//error错误信息
//url下载失败的imageurl
@property (nonatomic,copy) void(^downLoadImageError)(NSError *error,NSString *imageUrl);

@property (nonatomic,copy) void(^downLoadImageComplish)(UIImage *image,NSString *imageUrl);


+ (instancetype)shareManager;

- (void)downloadImageWithUrlString:(NSString *)urlSting;

@end
