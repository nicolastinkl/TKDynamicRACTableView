//
//  MLScrollRefreshHeader.m
//
//  Created by Molon on 13-11-7.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import "MLScrollRefreshHeader.h"
#import <AudioToolbox/AudioToolbox.h> //播放声音用到
#import "UIView+Additon.h"
#define kPullToRefreshText @"上拉刷新"
#define kReleaseToRefreshText @"松开刷新"
#define kRefreshingText @"正在加载..."

#define kViewHeight 65.0

#define kBundleName @"MLScrollRefreshHeader.bundle"
#define kSrcName(file) [kBundleName stringByAppendingPathComponent:file]

//当前刷新的状态
typedef enum {
    RefreshStateNormal,
	RefreshStatePulling,
	RefreshStateRefreshing
} RefreshState;

@interface MLScrollRefreshHeader()

@property (nonatomic, assign) CGFloat deaultTopInset;

@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIImageView * animationImageView;

@property (nonatomic, assign) RefreshState state;

@property (nonatomic, assign) BOOL isPlaySound;
//四种声音
@property (nonatomic, assign) SystemSoundID normalId;
@property (nonatomic, assign) SystemSoundID pullId;
@property (nonatomic, assign) SystemSoundID refreshingId;
@property (nonatomic, assign) SystemSoundID endRefreshId;

@end

@implementation MLScrollRefreshHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //自动适应宽度
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        //状态标签，字体13
        UILabel *label = [[UILabel alloc] init];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.stateLabel = label];
        self.stateLabel.hidden = YES;  // change by tinkl
        
        {
            //箭头图片,左右自适应
            UIImage *image = [UIImage imageNamed:@"loadingSpinnerSmallBlue"];
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:image];
            arrowImageView.width = 20;
            arrowImageView.height = 20;
            arrowImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [self addSubview:self.arrowImageView = arrowImageView]; //change by tinkl
            
            self.animationImageView = [[UIImageView alloc] initWithImage:image];;
            self.animationImageView.bounds = arrowImageView.bounds;
            self.animationImageView.autoresizingMask = _arrowImageView.autoresizingMask;
            [self addSubview:self.animationImageView]; //change by tinkl
            
        }
        
//        //指示器，系统默认，灰色样式，左右自适应
//        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activityView.bounds = arrowImageView.bounds;
//        activityView.autoresizingMask = _arrowImageView.autoresizingMask;
//        [self addSubview:self.activityView = activityView];
        
        
        
        
        
        //设置默认状态
        self.state = RefreshStateNormal;
        
        //声音ID获取
        self.pullId = [self loadSoundId:@"pull.wav"];
        self.normalId = [self loadSoundId:@"normal.wav"];
        self.refreshingId = [self loadSoundId:@"refreshing.wav"];
        self.endRefreshId = [self loadSoundId:@"end_refreshing.wav"];
    }
    return self;
}

//使用scrollView初始化
- (instancetype)initWithScrollView:(UIScrollView *)scrollView andDelegate:(id<MLScrollRefreshHeaderDelegate>)delegate isPlaySound:(BOOL)isPlaySound
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.isPlaySound = isPlaySound;
        
        self.deaultTopInset = scrollView.contentInset.top;
        self.scrollView = scrollView;
        
    }
    return self;
}

#pragma mark -实现内部

- (void)setScrollView:(UIScrollView *)scrollView
{
    //去除父View,其中删掉以前的observer
    [self removeFromSuperview];
    
    //赋值新的。
    _scrollView = scrollView;
    
    //根据scrollView的frame设置frame
    [super setFrame:CGRectMake(0, -_deaultTopInset-kViewHeight, _scrollView.bounds.size.width, kViewHeight)];
    //SubViews
    _stateLabel.frame = CGRectMake(0, kViewHeight/2-20, _scrollView.bounds.size.width, 20);
    _arrowImageView.center = CGPointMake(_scrollView.bounds.size.width/2, kViewHeight/2+_arrowImageView.frame.size.height/2+5);
    _activityView.center = _arrowImageView.center;
    _animationImageView.center = _arrowImageView.center;
    
    //设置对应scrollView的KVO
    [_scrollView addSubview:self];
    // 监听contentOffset
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

//在移除之前去除KVO
//这他娘的，按理说父类释放的时候会走这块，但是会提示没有删除KVO，所以在父View释放之前需要自己主动处理下
- (void)removeFromSuperview
{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
    [super removeFromSuperview];
}

- (void)setFrame:(CGRect)frame
{
    return;//外部不可设置，想设置，只能内部[super setFrame:XXX]
}


- (void)startAnimation{
    self.animationImageView.hidden = NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];///* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    
    [self.animationImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation{
    if (self.animationImageView) {
        [self.animationImageView.layer removeAllAnimations];
        self.animationImageView.hidden = YES;
    }
}

//根据当前state的设置来改变视图和其他
- (void)setState:(RefreshState)state
{
    if (_state == state) return;

    switch (state) {
		case RefreshStateNormal:
        {
            _arrowImageView.hidden = NO; //这俩一个位置，只能显示一个
			[_activityView stopAnimating];
            [self stopAnimation];
        }
			break;
        case RefreshStatePulling:
            break;
            
		case RefreshStateRefreshing:
        {
            [self startAnimation];
			[_activityView startAnimating];
			_arrowImageView.hidden = YES;
            _arrowImageView.transform = CGAffineTransformIdentity;
            
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshHeaderBeginRefreshing:)]) {
                [_delegate refreshHeaderBeginRefreshing:self];
            }
        }
			break;
	}
    
    //下面修改文字和图标指向啥的，维持contentInset
    RefreshState oldState = _state;
    _state = state;
	switch (state) {
		case RefreshStatePulling:
        {
            _stateLabel.text = kReleaseToRefreshText;
            
            /*
             rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
             rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ]; full rotation
             */
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImageView.transform = CGAffineTransformMakeRotation( M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _deaultTopInset;
                _scrollView.contentInset = inset;
            }];
			break;
        }
		case RefreshStateNormal:
        {
			_stateLabel.text = kPullToRefreshText;
            
            // 刷新完毕
            if (oldState == RefreshStateRefreshing) {
                if (_isPlaySound) {
                    AudioServicesPlaySystemSound(_endRefreshId);
                }
            }
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImageView.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _deaultTopInset;
                _scrollView.contentInset = inset;
            }];
			break;
        }
		case RefreshStateRefreshing:
        {
            _stateLabel.text = kRefreshingText;
            
            [UIView animateWithDuration:0.2 animations:^{
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _deaultTopInset+kViewHeight;
                _scrollView.contentInset = inset;
            }];
			break;
        }
	}

    
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"contentOffset" isEqualToString:keyPath]) {
        //这里针对header来说的
        //当自身不被touch响应时候，透明度都看不到时候，隐藏时候，正在刷新状态时候，
        //0-contentOffset.y小于等于0时候(就是没拉)，忽略
        CGFloat offsetY = _scrollView.contentOffset.y * -1;
        if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
            || _state == RefreshStateRefreshing
            || offsetY <= 0) return;
        
        //拖曳时候
        if (_scrollView.isDragging) {
            if (_state == RefreshStatePulling && offsetY <= _deaultTopInset+kViewHeight) {
                //转为普通状态
                if (_isPlaySound) {
                    AudioServicesPlaySystemSound(_normalId);
                }
                self.state = RefreshStateNormal;
            } else if (_state == RefreshStateNormal && offsetY > _deaultTopInset+kViewHeight) {
                //转为即将刷新状态
                if (_isPlaySound) {
                    AudioServicesPlaySystemSound(_pullId);
                }
                self.state = RefreshStatePulling;
            }
        } else {
            if (_state == RefreshStatePulling) {
                //开始刷新
                if (_isPlaySound) {
                    AudioServicesPlaySystemSound(_refreshingId);
                }
                self.state = RefreshStateRefreshing;
            }
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - other Common
- (SystemSoundID)loadSoundId:(NSString *)filename
{
    SystemSoundID ID;
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:kSrcName(filename) withExtension:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &ID);
    return ID;
}

// 结束刷新
- (void)endRefreshing{
    self.state = RefreshStateNormal;
}


#pragma mark - 主动操作
// 开始刷新
- (void)beginRefreshing{
    self.state = RefreshStateRefreshing;
}

@end
