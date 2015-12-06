//
//  DCPicScrollView.m
//  DCPicScrollView
//
//  Created by dengchen on 15/12/4.
//  Copyright © 2015年 name. All rights reserved.
//

#define pageSize 16
#define myWidth self.frame.size.width
#define myHeight self.frame.size.height
#import "DCPicScrollView.h"

@interface DCPicScrollView () <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableDictionary *webImageCache;

@property (nonatomic,copy) NSArray *imageData;

@property (nonatomic,copy) NSString *cachePath;

@end

@implementation DCPicScrollView{
    
    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
    
    __weak  UILabel *_leftLabel,*_centerLabel,*_rightLabel;
    
    __weak  UIScrollView *_scrollView;

    __weak  UIPageControl *_PageControl;
    
    NSTimer *_timer;
    
    NSInteger _currentIndex;
    
    NSInteger _MaxImageCount;
    
    BOOL _isNetwork;
    
    BOOL _hasTitle;
}


- (void)setMaxImageCount:(NSInteger)MaxImageCount {
    _MaxImageCount = MaxImageCount;
    
    [self prepareImageView];
    [self preparePageControl];
    
    [self setUpTimer];
    
    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
}


- (void)imageViewDidTap {
    if (self.imageViewDidTapAtIndex != nil) {
        self.imageViewDidTapAtIndex(_currentIndex);
    }
}


- (instancetype)initWithFrame:(CGRect)frame WithImageNames:(NSArray<NSString *> *)ImageName {
    if (ImageName.count < 2) {
        return nil;
    }
    self = [super initWithFrame:frame];
    
    [self prepareScrollView];
    [self setImageData:ImageName];
    [self setMaxImageCount:_imageData.count];

    return self;
}



- (void)prepareScrollView {
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:sc];
    
    _scrollView = sc;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(myWidth * 3,0);
    
    _AutoScrollDelay = 2.0f;
    _currentIndex = 0;
}

- (void)prepareImageView {
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,myWidth, myHeight)];
    UIImageView *center = [[UIImageView alloc] initWithFrame:CGRectMake(myWidth, 0,myWidth, myHeight)];
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(myWidth * 2, 0,myWidth, myHeight)];
    
    center.userInteractionEnabled = YES;
    [center addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
 
    [_scrollView addSubview:left];
    [_scrollView addSubview:center];
    [_scrollView addSubview:right];
    
    _leftImageView = left;
    _centerImageView = center;
    _rightImageView = right;
    
}

- (void)preparePageControl {
    
    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0,myHeight - pageSize,myWidth, 7)];
    
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    page.currentPageIndicatorTintColor =  [UIColor redColor];
    page.numberOfPages = _MaxImageCount;
    page.currentPage = 0;
    
    [self addSubview:page];
    
    
    _PageControl = page;
}

- (void)setTitleData:(NSArray<NSString *> *)titleData {
    if (titleData.count < 2)  return;
    
    if (titleData.count < _imageData.count) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:titleData];
        for (int i = 0; i < _imageData.count - titleData.count; i++) {
            [temp addObject:@""];
        }
        _titleData = [temp copy];
    }else {
        
        _titleData = [titleData copy];
    }
    
    [self prepareTitleLabel];
    _hasTitle = YES;
    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];

}


- (void)prepareTitleLabel {
    
    [self setStyle:PageControlAtRight];

   UIView *left = [self creatLabelBgView];
   UIView *center = [self creatLabelBgView];
   UIView *right = [self creatLabelBgView];
    
    _leftLabel = (UILabel *)left.subviews.firstObject;
    _centerLabel = (UILabel *)center.subviews.firstObject;
    _rightLabel = (UILabel *)right.subviews.firstObject;

    [_leftImageView addSubview:left];
    [_centerImageView addSubview:center];
    [_rightImageView addSubview:right];
    

}

- (UIView *)creatLabelBgView {
    CGFloat h = 25;
    
    if (myHeight * 0.1 > 25) {
        h = myHeight * 0.1;
    }
    
   UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, myHeight-h, myWidth, h)];
    v.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, myWidth-_PageControl.frame.size.width,h)];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:h*0.5];
    
    [v addSubview:label];
    
    return v;
}


- (void)setStyle:(PageControlStyle)style {
    if (style == PageControlAtRight) {
        CGFloat w = _MaxImageCount * pageSize;
        _PageControl.frame = CGRectMake(myWidth - w,myHeight-pageSize,w, 7);
    }
}

#pragma mark scrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeImageWithOffset:scrollView.contentOffset.x];
}


- (void)changeImageWithOffset:(CGFloat)offsetX {
    
    if (offsetX >= myWidth * 2) {
        _currentIndex++;
        
        if (_currentIndex == _MaxImageCount-1) {
            
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _MaxImageCount) {
            
            _currentIndex = 0;
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _PageControl.currentPage = _currentIndex;
        
    }
    
    if (offsetX <= 0) {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _MaxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        
        _PageControl.currentPage = _currentIndex;
    }
    
}


-(void)dealloc {
    [self removeTimer];
}

- (void)scorll {
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + myWidth, 0) animated:YES];
}

- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay {
    _AutoScrollDelay = AutoScrollDelay;
    [self removeTimer];
    [self setUpTimer];
}

- (void)setUpTimer {
    if (_AutoScrollDelay < 0.5) return;

    _timer = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)setImageData:(NSArray *)ImageNames {
    
    _isNetwork = [ImageNames.firstObject hasPrefix:@"http://"];
    
    if (_isNetwork) {
        
        _imageData = [ImageNames copy];
        
        [self getImage];
        
    }else {
        
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:ImageNames.count];
        
        for (NSString *name in ImageNames) {
            [temp addObject:[UIImage imageNamed:name]];
        }
        
        _imageData = [temp copy];
    }
    
}


- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex {
    
    if (_isNetwork) {
        
        _leftImageView.image = [self setImageWithIndex:LeftIndex];
        _centerImageView.image = [self setImageWithIndex:centerIndex];
        _rightImageView.image = [self setImageWithIndex:rightIndex];
        
    }else {
        
        _leftImageView.image = _imageData[LeftIndex];
        _centerImageView.image = _imageData[centerIndex];
        _rightImageView.image = _imageData[rightIndex];
        
    }
    
    if (_hasTitle) {
        
        _leftLabel.text = _titleData[LeftIndex];
        _centerLabel.text = _titleData[centerIndex];
        _rightLabel.text = _titleData[rightIndex];
        
    }
    
    [_scrollView setContentOffset:CGPointMake(myWidth, 0)];
}

- (BOOL)LoadDiskCacheWithUrlString:(NSString *)urlSting {
    //取沙盒缓存
    NSData *data = [NSData dataWithContentsOfFile:[self.cachePath stringByAppendingPathComponent:urlSting.lastPathComponent]];
    
    if (data.length > 0 ) {
        
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            [self.webImageData setObject:image forKey:urlSting];
            return YES;
        }else {
            [[NSFileManager defaultManager] removeItemAtPath:[self.cachePath stringByAppendingPathComponent:urlSting.lastPathComponent] error:NULL];
        }
    }
    return NO;
}

- (void)getImage {
    
    
    for (NSString *urlSting in _imageData) {
        
        if ([self LoadDiskCacheWithUrlString:urlSting]) {
            continue;
        }
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            
            [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlSting] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

                [self downLoadImagefinish:data
                                      url:urlSting
                                 savePath:[self.cachePath stringByAppendingPathComponent:urlSting.lastPathComponent]
                                    error:error];
                
            }] resume];
            
        }else {
            
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlSting]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

                [self downLoadImagefinish:data
                                      url:urlSting
                                 savePath:[self.cachePath stringByAppendingPathComponent:urlSting.lastPathComponent]
                                    error:connectionError];
            }] ;
            
        }
    }
    
}

- (void)downLoadImagefinish:(NSData *)data url:(NSString *)urlString savePath:(NSString *)path error:(NSError *)error {
    UIImage *image = [UIImage imageWithData:data];
    
    if (error) {
        if (self.downLoadImageError) {
            self.downLoadImageError(error,urlString);
        }
        return ;
    }
    
    if (!image) {
        
        NSString *errorData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *error = [NSError errorWithDomain:errorData code:381 userInfo:nil];
        
        if (self.downLoadImageError) {
            self.downLoadImageError(error,urlString);
        }
        return ;
    }
    
    //                沙盒缓存
    [data writeToFile:[path stringByAppendingPathComponent:urlString.lastPathComponent] atomically:YES];
    //                内存缓存
    [self.webImageData setObject:image forKey:urlString];
    
}




- (UIImage *)setImageWithIndex:(NSInteger)index {
    
    //从内存缓存中取,如果没有使用占位图片
    UIImage *image = [self.webImageCache valueForKey:_imageData[index]];
    if (image) {
        return image;
    }else {
        return _placeImage;
    }
}

- (NSMutableDictionary *)webImageData {
    if (!_webImageCache) {
        _webImageCache = [[NSMutableDictionary alloc] init];
    }
    return _webImageCache;
}

- (NSString *)cachePath {
    if (!_cachePath) {
        _cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    return _cachePath;
}

//
//- (void)getImage {
//   
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    
//    for (NSString *urlString in _imageData) {
//        
//        [manager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageHighPriority progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            if (error) {
//                NSLog(@"%@",error);
//            }
//        }];
//    }
//    
//}
//- (UIImage *)setImageWithIndex:(NSInteger)index {
//    
//  UIImage *image =
//    [[[SDWebImageManager sharedManager] imageCache] imageFromMemoryCacheForKey:_imageData[index]];
//    if (image) {
//        return image;
//    }else {
//        return _placeImage;
//    }
//    
//}







@end












