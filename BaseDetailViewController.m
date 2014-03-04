//
//  BaseDetailViewController.m
//  RefreshTable
//
//  Created by Molon on 13-11-7.
//  Copyright (c) 2013年 Molon. All rights reserved.
//

#import "BaseDetailViewController.h"
#import "XCJGroupPost_list.h"
#import "Comment.h"
#import "MLScrollRefreshHeader.h"
#import "InterceptTouchView.h"
#import "ActivityTableViewCell.h"
#import "Extend.h"
#import "UIView+Additon.h"
#import "UIView+Indicator.h"
#import "XCAlbumAdditions.h"
#import "FCUserDescription.h"



//#import "MobClick.h"
#define kLoadMoreCellHeight 40


@interface BaseDetailViewController () <UITableViewDataSource,UITableViewDelegate,MLScrollRefreshHeaderDelegate,ActivityTableViewCellDelegate,UITextViewDelegate,InterceptTouchViewDelegate>


@property (nonatomic,strong) UIView *inputView;
@property (nonatomic,strong) UITextView *inputTextView;
@property (nonatomic,strong) UIImageView *inputTextBackView;

@property (nonatomic,assign) CGFloat tableBaseYOffsetForInput;

@property (nonatomic,strong) XCJGroupPost_list* currentOperateActivity;
@property (nonatomic,assign) NSInteger currentCommentToUserIndex;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) BOOL isDontNeedLazyLoad;

@property (nonatomic,strong) UITableViewCell *moreCell;

@end


@implementation BaseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    //这个地需要明确调用下。。
    [_refreshView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
    
    [_inputTextView removeObserver:self forKeyPath:@"contentSize" context:nil];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSArray *ws = [[UIApplication sharedApplication] windows];
    for(UIView *w in ws){
        NSArray *vs = [w subviews];
        for(UIView *v in vs){
            if([[NSString stringWithUTF8String:object_getClassName(v)] isEqualToString:@"UIKeyboard"]){
                v.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIView *origView = self.view;
    self.view = [[InterceptTouchView alloc]initWithFrame:origView.frame];
    
    ((InterceptTouchView*)self.view).interceptTouchViewDelegate = self;
    
    origView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.activities = [[NSMutableArray alloc]initWithCapacity:1];
    self.cellHeights = [[NSMutableArray alloc]initWithCapacity:1];
    
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"Molon" forHTTPHeaderField:@"AppName"];
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    
    //很奇葩的，不知道为什么，在第一次reloadData成功之后TopInset会莫名其妙多20。
    //对当前VC这样设置无多余布局空间就解决了。。。
    self.edgesForExtendedLayout = UIRectEdgeNone;
 
    [self.titleString  addObserver:self forKeyPath:@"changeTitle" options:NSKeyValueObservingOptionNew context:nil];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollsToTop = YES;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    UIEdgeInsets insets =  _tableView.contentInset;
    insets.top = [self topInsetOfTableView:_tableView];
    _tableView.contentInset = insets;
    
    self.refreshView = [[MLScrollRefreshHeader alloc]initWithScrollView:self.tableView andDelegate:self isPlaySound:NO];
    
    //评论输入框
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frameBottom,self.view.frameWidth, 47)];
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.layer.borderColor = [UIColor grayColor].CGColor;
    _inputView.layer.borderWidth = .5f;
    [self.view addSubview:_inputView];
    
    UIImageView *textBackView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, _inputView.frameWidth-8*2, _inputView.frameHeight-6*2)];
    textBackView.image = [[UIImage imageNamed:@"edit_text_bg.png"]stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f];
    [_inputView addSubview:self.inputTextBackView = textBackView];
    
    self.inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(textBackView.frameX+5, textBackView.frameY+1, textBackView.frameWidth-5*2, textBackView.frameHeight-1*2)];
    _inputTextView.clipsToBounds = YES;
    self.inputTextView.delegate = self;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.font = [UIFont systemFontOfSize:14];
    _inputTextView.scrollsToTop = NO;
    [_inputView addSubview:_inputTextView];
    
    //监视输入内容大小，在KVO里自动调整
    [_inputTextView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.noDataHintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, _tableView.frameWidth, 50)];
    _noDataHintLabel.textAlignment = NSTextAlignmentCenter;
    _noDataHintLabel.textColor = [UIColor grayColor];
    _noDataHintLabel.text = @"没有数据";
    _noDataHintLabel.font = [UIFont boldSystemFontOfSize:15];
    _noDataHintLabel.hidden = YES;
    [_tableView addSubview:_noDataHintLabel];
    
    //先显示指示器
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    SLog(@"_activities.count : %d",_activities.count);
     return _activities.count;
    
    if (_isDontNeedLazyLoad) {
        return _activities.count;
    }
    return _activities.count+1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)activityCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//lazy loading
    
    XCJGroupPost_list* activity = _activities[indexPath.row];
    ActivityTableViewCell *cell = (ActivityTableViewCell *)activityCell;
    
    if (activity.replycount > 0 && activity.comments.count <= 0 && !cell.HasLoad) {
        /* get all list data*/
        cell.HasLoad = YES;
        NSDictionary * parames = @{@"postid":activity.postid,@"pos":@0,@"count":@"1000"};
        [[MLNetworkingManager sharedManager] sendWithAction:@"post.get_reply"  parameters:parames success:^(MLRequest *request, id responseObject) {
            //    postid = 12;
            /*
             Result={
             “posts”:[*/
            NSDictionary * groups = responseObject[@"result"];
            NSArray * postsDict =  groups[@"replys"];
            if (postsDict && postsDict.count > 0) {
                NSMutableArray * mutaArray = [[NSMutableArray alloc] init];
                [postsDict enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    Comment * comment = [Comment turnObject:obj];
                    [mutaArray addObject:comment];
                    
                }];
                [activity.comments addObjectsFromArray:mutaArray];
                //indexofActivitys
                [self reloadSingleActivityRowOfTableView:[self.activities indexOfObject:activity] withAnimation:NO];
            }
            cell.HasLoad = YES;
        } failure:^(MLRequest *request, NSError *error) {
            cell.HasLoad = NO;
        }];
    }
    
    if (activity.excount > 0) {
        if (activity.excountImages.count <= 0 && !cell.isloadingphotos) {
            //check from networking
            cell.isloadingphotos = YES;
            [[MLNetworkingManager sharedManager] sendWithAction:@"post.readex" parameters:@{@"postid":activity.postid} success:^(MLRequest *request, id responseObject) {
                if (responseObject) {
                    NSDictionary  * result = responseObject[@"result"];
                    NSArray * array = result[@"exdata"];
                    NSMutableArray * arrayURLS  = [[NSMutableArray alloc] init];
                    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSString * stringurl = [DataHelper getStringValue:obj[@"picture"] defaultValue:@"" ];
                        [arrayURLS addObject:stringurl];
                    }];
                    [activity.excountImages removeAllObjects];
                    [activity.excountImages addObjectsFromArray:arrayURLS];
//                    [_tableView reloadData];
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                cell.isloadingphotos = NO;
            } failure:^(MLRequest *request, NSError *error) {
                cell.isloadingphotos = NO;
            }];
        }
        
    }
    
    if (_isDontNeedLazyLoad) {
        return;
    }
    if ((indexPath.row) >= (NSInteger)(_activities.count-1)) {
        if (!_isLoading) {
            self.isLoading = YES;
            [self postLoadMoreActivitiesRequest];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (indexPath.row>=_activities.count) {
     static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
     UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
     if (moreCell == nil) {
     moreCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
     
     moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
     moreCell.backgroundColor = [UIColor clearColor];
     
     UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     indicator.frameSize = CGSizeMake(20, 20);
     indicator.center = CGPointMake(self.view.frameWidth/2, kLoadMoreCellHeight/2);
     indicator.tag = 888;
     indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
     [moreCell addSubview:indicator];
     
     UIButton *retryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, moreCell.frameWidth, moreCell.frameHeight)];
     retryButton.backgroundColor = [UIColor clearColor];
     [retryButton setTitle:@"点击重新加载" forState:UIControlStateNormal];
     retryButton.titleLabel.font = [UIFont systemFontOfSize:14];
     retryButton.tag = 111;
     retryButton.titleLabel.textColor = [UIColor grayColor];
     [retryButton addTarget:self action:@selector(retryButtonEvent) forControlEvents:UIControlEventTouchUpInside];
     [moreCell addSubview:retryButton];
     }
     self.moreCell = moreCell;
     
     UIButton *button = (UIButton *)[moreCell viewWithTag:111];
     UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[moreCell viewWithTag:888];
     [indicator startAnimating];
     button.hidden = YES;
     //        [self.moreCell showIndicatorViewBlue];
     return moreCell;
     }*/
    
    static NSString *CellIdentifier = @"Cell";
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    XCJGroupPost_list* activity = _activities[indexPath.row];
    cell.needRefreshViewController = self;
    if (activity.like > 0 && !cell.HasLoadlisks) {
        cell.HasLoadlisks = YES;
       /*
        NSDictionary * parames = @{@"postid":activity.postid,@"pos":@0,@"count":@"100"};
        [[MLNetworkingManager sharedManager] sendWithAction:@"post.likes" parameters:parames success:^(MLRequest *request, id responseObject) {
        NSDictionary * groups = responseObject[@"result"];
        NSArray * postsDict =  groups[@"users"];
        if (postsDict&& postsDict.count > 0) {
        NSMutableArray * mutaArray = [[NSMutableArray alloc] init];
        [postsDict enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        postlikes * likes = [postlikes turnObject:obj];
        [mutaArray addObject:likes];
        }];
        
        [activity.likeUsers addObjectsFromArray:mutaArray];
        //indexofActivitys
        //[self reloadSingleActivityRowOfTableView:[self.activities indexOfObject:activity] withAnimation:NO];
        }
        cell.HasLoadlisks = YES;
        } failure:^(MLRequest *request, NSError *error) {
        cell.HasLoadlisks =YES;
        
        }];
        */
    }

//    cell.indexofActivitys =  [self.activities indexOfObject:activity];
    cell.activity = activity;
    // start requst comments  and likes
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    XCJGroupPost_list *activity = _activities[indexPath.row];
//    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    return [cell heigthforCell:activity] + 20;
    
//    if (indexPath.row>=_activities.count) {
//        return kLoadMoreCellHeight;
//    }
    
    XCJGroupPost_list *activity = [_activities objectAtIndex:indexPath.row];
    if (activity) {
        if (_cellHeights&&[_cellHeights[indexPath.row] floatValue]>0) {
            return [_cellHeights[indexPath.row] floatValue];
        }
        
        static NSString *CellIdentifier = @"Cell";
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.activity = _activities[indexPath.row];
        
        [_cellHeights replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:cell.cellHeight]];
        
        return cell.cellHeight;
    }
    return 46+10*2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - ActivityTableViewCellDelegate
//点击某用户名
- (void)clickUserID:(NSString *)uid onActivity:(XCJGroupPost_list *)activity
{
    NSLog(@"点击用户id:%@",uid);
}

//点击当前activity的发布者头像
- (void)clickAvatarButton:(UIButton *)avatarButton onActivity:(XCJGroupPost_list *)activity
{
    NSLog(@"点击头像:%@",avatarButton);
}

//点击评论按钮
- (void)clickCommentButton:(UIButton *)commentButton onActivity:(XCJGroupPost_list *)activity
{
    //滚动到指定activity的底部-10像素
    NSInteger index = [_activities indexOfObject:activity];
    CGRect rectOfCellInTableView = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    self.tableBaseYOffsetForInput = rectOfCellInTableView.origin.y+rectOfCellInTableView.size.height-10;
    
    self.currentOperateActivity = activity;
    self.currentCommentToUserIndex = -1;
    [_inputTextView becomeFirstResponder];
}

//点击赞按钮
- (void)clickLikeButton:(UIButton *)likeButton onActivity:(XCJGroupPost_list *)activity{
    NSLog(@"点击赞:%@",likeButton);
    //在activity
}

- (void)clickDeleteButton:(UIButton *)commentButton onActivity:(XCJGroupPost_list *)activity
{
    
}

//点击评论View中的某行(当前如果点击的是其中的某用户是会忽略的)
- (void)clickCommentsView:(UIView *)commentsView atIndex:(NSInteger)index atBottomY:(CGFloat)bottomY onActivity:(XCJGroupPost_list *)activity
{
    //滚动到指定activity的底部-5像素
    NSInteger acindex = [_activities indexOfObject:activity];
    CGRect rectOfCellInTableView = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:acindex inSection:0]];
    
    self.tableBaseYOffsetForInput = rectOfCellInTableView.origin.y+commentsView.frameY+bottomY;
    
    self.currentOperateActivity = activity;
    self.currentCommentToUserIndex = index;
    Comment * comment = self.currentOperateActivity.comments[self.currentCommentToUserIndex];
    if(![comment.uid isEqualToString:[USER_DEFAULT stringForKey:KeyChain_Laixin_account_user_id]])
    {
        // if is me...
        [[[LXAPIController sharedLXAPIController] requestLaixinManager] getUserDesPtionCompletion:^(id response, NSError * error) {
            FCUserDescription * user = response;
            _inputTextView.text = [NSString stringWithFormat:@"@%@:",user.nick];
            [_inputTextView becomeFirstResponder];
        } withuid:comment.uid];
    }else{
        _inputTextView.text = @"";
        [_inputTextView becomeFirstResponder];
    }
    
    
}

#pragma mark - TextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        if (![_inputTextView.text isNilOrEmpty]&&_currentOperateActivity) {
            
            [self sendCommentContent:_inputTextView.text ToActivity:_currentOperateActivity atCommentIndex:_currentCommentToUserIndex];
            
            self.currentOperateActivity = nil;
            self.currentCommentToUserIndex = -1;
            
            _inputTextView.text = @"";
            [_inputTextView resignFirstResponder];
        }
        return NO;
    };
    return YES;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]){
        //高度最大为80
        static CGFloat maxHeight = 80;
        
        CGFloat origHeight = _inputTextView.frameHeight;
        _inputTextView.frameHeight = (_inputTextView.contentSize.height<=maxHeight)?_inputTextView.contentSize.height:maxHeight;
        
        CGFloat offset = _inputTextView.frameHeight - origHeight;
        
        _inputTextBackView.frameHeight +=offset;
        _inputView.frameHeight +=offset;
        _inputView.frameY -=offset;
        
        //tableView的位置也修正下
        _tableView.contentOffset = CGPointMake(0, _tableView.contentOffset.y+offset);
    }
    
    if ([keyPath isEqualToString:@"changeTitle"]) {
        self.titleString = [NSString stringWithFormat:@"%@",object];
//        self.titleview.titleView.text = self.titleString;
//        [self.titleview.titleView sizeToFit];
    }
   // [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGFloat newY = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - _inputView.frameHeight;//-64

    _tableView.userInteractionEnabled = NO;
    
    //调整tableView的位置
    CGFloat newYOffset = _tableView.contentOffset.y;
    if (_tableBaseYOffsetForInput) {
        newYOffset = _tableBaseYOffsetForInput-(newY-_tableView.frameY);
        if (newYOffset<0) { //最顶部
            newYOffset = 0;
        }
    }
    
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                          CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                         _inputView.frameY =  self.view.height - keyboardFrame.size.height - 44;// newY;
                         _tableView.contentOffset = CGPointMake(0, newYOffset + 70);
                     }
                    completion:^(BOOL finished) {
                        _tableView.userInteractionEnabled = YES;
                    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    _tableView.userInteractionEnabled = NO;
    
    //调整tableView位置
    if (_tableView.contentOffset.y > _tableView.contentSize.height-_tableView.frameHeight) {//最底部
        if (_activities.count > 0) {
            
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_activities.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
    }
    
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         _inputView.frameY = self.view.frameBottom + 100;
                     }
                     completion:^(BOOL finished) {
                         _tableView.userInteractionEnabled = YES;
                     }];
}

#pragma mark - MLScrollRefreshHeaderDelegate
- (void)refreshHeaderBeginRefreshing:(MLScrollRefreshHeader *)refreshHeader
{
    self.isLoading = YES;
    _noDataHintLabel.hidden = YES;
    // hide error message
//    
//    UIButton *button = (UIButton *)[self.moreCell viewWithTag:111];
//    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.moreCell viewWithTag:888];
//    button.hidden = YES;
//    [indicator stopAnimating];
    
    NSInteger lastID = 0;
    if (_activities.count>0) {
        lastID = [((XCJGroupPost_list*)_activities[0]).postid integerValue];
    }
    if (lastID == 0) {
        [self postGetActivitiesWithLastID:lastID withType:Enum_initData];
    }else{
        [self postGetActivitiesWithLastID:lastID withType:Enum_UpdateTopData];
    }
    
}

#pragma mark - InterceptTouchViewDelegate
- (BOOL)interceptTouchWithView:(UIView *)view
{
    if (![view isEqual:_inputTextView]&&[_inputTextView isFirstResponder]) {
        [_inputTextView resignFirstResponder];
        return YES;
    }
    return NO;
}

#pragma mark - other Common

- (void)reloadSingleActivityRowOfTableView:(NSInteger)row withAnimation:(BOOL)animation
{
    if (row>=_activities.count||row<0) {
        return;
    }
    _noDataHintLabel.hidden = YES;
    [_cellHeights replaceObjectAtIndex:row withObject:@0];
    [_tableView reloadData];
    
    if (row == _activities.count-1) {
//        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_activities.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
//    NSArray *arr = @[[NSIndexPath indexPathForRow:row inSection:0]];
//    
//    Activity *ac = _activities[row];
//    //先删除
//    [_activities removeObjectAtIndex:row];
//    [_cellHeights removeObjectAtIndex:row];
//    [_tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
//    
//    [_cellHeights insertObject:@0 atIndex:row];
//    [_activities insertObject:ac atIndex:row];
//    if (animation) {
//        [_tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
//    }else{
//        [_tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
//    }
}

/**
 *  加载新的内容
 *
 *  @return 这次新的条目数
 */
- (void)postLoadMoreActivitiesRequest
{
    NSInteger lastID = 0;
    if (_activities.count >= 20) {
        lastID = [((XCJGroupPost_list*)_activities[_activities.count-1]).postid integerValue];
        self.isLoading = YES;
        _noDataHintLabel.hidden = YES;
        [self postGetActivitiesWithLastID:lastID withType:Enum_MoreData];
    }else{
        self.isLoading = NO;
    }
}

/**
 *  在获取结果成功之后postGetActivitiesWithLastID中需要调用的方法
 *  lastID需要原样返回，和postGetActivitiesWithLastID的参数对应
 *  @param activities 新数据结果
 *  @param lastID     上个activity的ID，没有则为0
 */
- (void)successGetActivities:(NSArray*)activities withLastID:(NSInteger)lastID
{
    self.isLoading = NO;

    dispatch_async(dispatch_get_main_queue(), ^{
        _noDataHintLabel.hidden = YES;
        if (_activities.count<=0&&activities.count<=0) {
            _noDataHintLabel.hidden = NO;
        }
    });
    
    if ((!activities || activities.count<=0)&&!_isDontNeedLazyLoad) {
        //如果没有新的，那就不需要懒加载了。
        self.isDontNeedLazyLoad = YES;
//        NSArray *arr = @[[NSIndexPath indexPathForRow:_activities.count inSection:0]];
//        //删除最后一行
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
//        });
//        
//        return;
    }
    
//    if (lastID<=0) {
//        //开启懒加载
//        self.isDontNeedLazyLoad = NO;
//        //清空数据源
//        [_cellHeights removeAllObjects];
//        [_activities removeAllObjects];
//    } else if (_activities.count>0&&lastID!=[((XCJGroupPost_list*)_activities[_activities.count-1]).postid integerValue]) {
////        //这里得判断当前最后一个activity ID是不是和lastID对应，不是则什么都不做
////        //假想一个场景，先有loadMore请求，然后有refresh请求，然后refresh先有结果，然后loadMore再有结果。
////        //More之前的数据就会有问题。
////        return;
//    }
    
    //加入新数据
    for (NSInteger i = 0; i<activities.count; i++) {
        [_cellHeights addObject:@0];
    }
//
    if (lastID == 0) { //reload的就直接重刷新tableView吧
//        [_activities addObjectsFromArray:activities];
        //return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_refreshView endRefreshing];
    });
    
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:activities.count];
//    for (NSInteger i = activities.count-1; i>=0; i--) {
//        [arr addObject:[NSIndexPath indexPathForRow:_activities.count-1-i inSection:0]];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
//    });
}

- (void)failedGetActivitiesWithLastID:(NSInteger)lastID
{
    self.isLoading = NO;
    [_refreshView endRefreshing];
    
    if (_isDontNeedLazyLoad) return;
    
//    UIButton *button = (UIButton *)[self.moreCell viewWithTag:111];
//    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.moreCell viewWithTag:888];
//    button.hidden = NO;
//    [indicator stopAnimating];
//    [self.moreCell hideIndicatorViewBlueOrGary];
}

- (void)retryButtonEvent
{
//    UIButton *button = (UIButton *)[self.moreCell viewWithTag:111];
//    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.moreCell viewWithTag:888];
//    button.hidden = YES;
//    [indicator startAnimating];
//    [self.moreCell hideIndicatorViewBlueOrGary];
    [self postLoadMoreActivitiesRequest];
}

#pragma mark - 需要子类继承的一些
/**
 *  根据lastID来获取activities，
 *  需要实现为0时候可最新内容
 *
 *  @param lastID 为0时候可最新内容，其他值的时候，获取比其ID小的最新
 *
 *  @return 返回多少条数据，自己定
 */
- (void)postGetActivitiesWithLastID:(NSInteger)lastID withType:(NSInteger) typeIndex
{
    
}

- (void)sendCommentContent:(NSString*)content ToActivity:(XCJGroupPost_list*)currentOperateActivity atCommentIndex:(NSInteger)commentIndex
{
    
    
}

//可在inset留顶部空间，然后在其位置添加自定义View
- (CGFloat)topInsetOfTableView:(UITableView*)tableView
{
    return 0;
}

@end
