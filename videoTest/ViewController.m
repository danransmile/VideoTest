
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Extension.h"
#define IMAGECOUNT 4
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)AVAudioSession *avaudioSession;
@property(nonatomic,strong) MPMoviePlayerController *player;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /** 设置其他音乐软件播放的音乐不被打断 */
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"1.mp4" ofType:nil];
    
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    
    self.player = [[MPMoviePlayerController alloc]initWithContentURL:url];
    [self.player.view setFrame:self.view.bounds];
    [self.view addSubview:self.player.view];
    [self.player setRepeatMode:MPMovieRepeatModeOne];
    self.player.shouldAutoplay = YES;
    [self.player setControlStyle:MPMovieControlStyleNone];
    [self.player setFullscreen:YES];
    [self.player play];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbackStateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
    UIView *transparentView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:transparentView];
    transparentView.backgroundColor = [UIColor clearColor];
    
    /** 配置scrollView */
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.delegate = self;
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    self.scrollView.bounces = NO;//配置边缘不可以弹跳
    self.scrollView.pagingEnabled = YES;//设置整页滚动
    self.scrollView.showsHorizontalScrollIndicator = NO;//设置水平滚动条不可见
    self.scrollView.contentSize = CGSizeMake(IMAGECOUNT *self.scrollView.frame.size.width, 0);//竖直方向不想滚动设置为0
    /** 配置PageControl */
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.width = self.view.width;
    self.pageControl.height = 40;
    self.pageControl.y = self.view.height - 60;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];//没有选中的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];//选中的颜色
    self.pageControl.numberOfPages = IMAGECOUNT;//圆点数量
    self.pageControl.userInteractionEnabled = NO;//禁止与用户交互
    if (self.pageControl.numberOfPages == 1) {
        self.pageControl.hidden = YES;
    }
    [transparentView addSubview:self.pageControl];
    UILabel *titleLabel = nil;
    
    NSArray *titleArray = @[@"1",@"2",@"3",@"4"];

    for (NSInteger i = 0; i< IMAGECOUNT;i++ ) {
        NSLog(@"i:%ld",i);
        titleLabel = [[UILabel alloc]init];
        titleLabel.tag = i;
         [self.scrollView addSubview:(UIButton *)[titleLabel viewWithTag:i]];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.left.mas_equalTo(self.view.width/2 - titleLabel.width/2 + i * self.view.size.width);
            make.bottom.mas_equalTo(self.pageControl.mas_top).mas_equalTo(-100);
        }];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:30];
        if (i == IMAGECOUNT) {
            
        }
    }
    

    
    

}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = self.scrollView.contentOffset;
    double i = offset.x/self.scrollView.width;
    self.pageControl.currentPage = round(i);
}
-(void)playbackStateChanged{
    MPMoviePlaybackState playbackState;
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
            [self.player play];
            break;
            
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放中");
            break;
            
        case MPMoviePlaybackStatePaused:
            [self.player play];
            break;
            
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"播放被中断");
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"往前快转");
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"往后快转");
            break;
            
        default:
            NSLog(@"无法辨识的状态");
            break;
    }

}


@end
