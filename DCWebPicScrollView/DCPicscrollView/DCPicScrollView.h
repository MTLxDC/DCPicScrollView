//
//  basePicScrollView.h
//  DCWebPicScrollView
//
//  Created by dengchen on 15/12/5.
//  Copyright © 2015年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PageControlStyle) {
    PageControlAtCenter,
    PageControlAtRight,
};

@interface DCPicScrollView : UIView

//占位图片
@property (nonatomic,strong) UIImage *placeImage;

@property (nonatomic,assign) NSTimeInterval AutoScrollDelay; //default is 2.0f,如果小于0.5不自动播放

//设置PageControl位置
@property (nonatomic,assign) PageControlStyle style; //default is PageControlAtCenter

@property (nonatomic,strong) NSArray<NSString *> *titleData; //设置后显示label,自动设置PageControlAtRight

//图片被点击会调用该block
@property (nonatomic,copy) void(^imageViewDidTapAtIndex)(NSInteger index); //index从0开始

@property (nonatomic,copy) void(^downLoadImageError)(NSError *error,NSString *imageUrl);

                                                            //imageUrlString或imageName
- (instancetype)initWithFrame:(CGRect)frame WithImageNames:(NSArray<NSString *> *)ImageName;

                                                        //网络加载urlsring必须为http:// 开头,
                                                        //如有特需修改284行代码
                                                        //本地加载只需图片名字数组
@end

