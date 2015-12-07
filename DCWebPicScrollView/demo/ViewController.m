//
//  ViewController.m
//  DCWebPicScrollView
//
//  Created by dengchen on 15/12/4.
//  Copyright © 2015年 name. All rights reserved.
//

#import "ViewController.h"
#import "DCPicScrollView.h"
#import "DCWebImageManager.h"

@interface ViewController ()

@end

CGFloat h = 150;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self demo1];
    
    [self demo2];
}

- (void)demo1 {
    
    //网络加载
    
    
    NSArray *arr = @[@"http://p1.qqyou.com/pic/UploadPic/2013-3/19/2013031923222781617.jpg",
                     @"http://cdn.duitang.com/uploads/item/201409/27/20140927192649_NxVKT.thumb.700_0.png",
                     @"http://img4.duitang.com/uploads/item/201409/27/20140927192458_GcRxV.jpeg",
                     @"http://cdn.duitang.com/uploads/item/201304/20/20130420192413_TeRRP.thumb.700_0.jpeg",
                     @"http://img3.imgtn.bdimg.com/it/u=1686576823,3500450034&fm=116&gp=0.jpg"];
    
    
   NSArray *arr1 = [@"午夜寂寞 谁来陪我,唱一首动人的情歌.你问我说 快不快乐,唱情歌越唱越寂寞.谁明白我 想要什么,一瞬间释放的洒脱.灯光闪烁 不必啰嗦,我就是传说中的那个摇摆哥.我是摇摆哥 音乐会让我快乐,我是摇摆哥 我已忘掉了寂寞.我是摇摆哥 音乐会让我洒脱,我们一起唱这摇摆的歌" componentsSeparatedByString:@"."];
    
    DCPicScrollView  *picView = [[DCPicScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h * 2) WithImageNames:arr];
   
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        NSLog(@"%@",error);
    }];
    
    picView.titleData = arr1;
    picView.placeImage = [UIImage imageNamed:@"place.png"];
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("你点到我了😳index:%zd\n",index);
    }];
    picView.AutoScrollDelay = 1.0f;
    [self.view addSubview:picView];
    
}




//本地加载
-(void)demo2 {
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 8; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%d.jpg",i]];
        [arr3 addObject:[NSString stringWithFormat:@"我是第%d张图片啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊",i]];
    };
    
    
    DCPicScrollView  *picView1 = [[DCPicScrollView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height - h,self.view.frame.size.width, h) WithImageNames:arr2];
    picView1.titleData = arr3;
    
    picView1.backgroundColor = [UIColor clearColor];
    [picView1 setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("你点到我了😳index:%zd\n",index);
    }];

    picView1.AutoScrollDelay = 2.0f;
    
    [self.view addSubview:picView1];
}

@end
