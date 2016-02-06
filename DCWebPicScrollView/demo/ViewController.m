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

static CGFloat h = 50;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self demo1];
    
    [self demo2];
}

- (void)demo1 {
    
    //网络加载
    
    NSArray *UrlStringArray = @[@"http://p1.qqyou.com/pic/UploadPic/2013-3/19/2013031923222781617.jpg"];
    

   NSArray *titleArray = [@"午夜寂寞 谁来陪我,唱一首动人的情歌.你问我说 快不快乐,唱情歌越唱越寂寞.谁明白我 想要什么,一瞬间释放的洒脱.灯光闪烁 不必啰嗦,我就是传说中的那个摇摆哥.我是摇摆哥 音乐会让我快乐,我是摇摆哥 我已忘掉了寂寞.我是摇摆哥 音乐会让我洒脱,我们一起唱这摇摆的歌" componentsSeparatedByString:@"."];
    
    
    //显示顺序和数组顺序一致
    //设置图片url数组,和滚动视图位置
    
    DCPicScrollView  *picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h*2) WithImageUrls:UrlStringArray];
    
    //显示顺序和数组顺序一致
    //设置标题显示文本数组


    
    picView.titleData = titleArray;
    
    //占位图片,你可以在下载图片失败处修改占位图片
    
//    picView.placeImage = [UIImage imageNamed:@"place.png"];
    
    //图片被点击事件,当前第几张图片被点击了,和数组顺序一致
    
    [picView setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("第%zd张图片\n",index);
    }];
    
    //default is 2.0f,如果小于0.5不自动播放
    picView.AutoScrollDelay = 1.0f;
//    picView.textColor = [UIColor redColor];
    
    [self.view addSubview:picView];
    
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    //error错误信息
    //url下载失败的imageurl
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        NSLog(@"%@",error);
    }];
}




//本地加载只要放图片名数组就行了

-(void)demo2 {
    
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 2; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%d.jpg",i]];
        [arr3 addObject:[NSString stringWithFormat:@"我是第%d张图片啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊",i]];
    };
    
    
    DCPicScrollView  *picView1 = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0,self.view.frame.size.height - h*5,self.view.frame.size.width, h*2) WithImageUrls:arr2];
    
    picView1.style = PageControlAtCenter;
    picView1.titleData = arr3;
    
    picView1.backgroundColor = [UIColor clearColor];
    [picView1 setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("你点到我了😳index:%zd\n",index);
    }];

    picView1.AutoScrollDelay = 2.0f;
    
    [self.view addSubview:picView1];
}

@end
