//
//  SCBrowseView.m
//  SocialCalendar
//
//  Created by yang on 15/10/31.
//  Copyright © 2015年 Lianxi.com. All rights reserved.
//

#import "SCBrowseView.h"
#import "SCBrowseScrollView.h"
#import "NSMutableArray+LDYCategory.h"

@interface SCBrowseView()<UIScrollViewDelegate,SCBrowseScrollViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong)   UIScrollView            *scrollView;
@property (nonatomic, assign)   CGRect                  fromRect;
@property (nonatomic, assign)   SCBrowseDirection       direction;
@property (nonatomic, strong)   NSMutableArray          *browseScrollviewArray;
@property (nonatomic, assign)   NSInteger               showImageCount;
@property (nonatomic, assign)   SCBrowseStyle           browseStyle;
@end

@implementation SCBrowseView

- (instancetype)initWithFrame:(CGRect)frame
                  mediasArray:(NSMutableArray *)mediasArray
                     fromRect:(CGRect)fromRect
                        index:(NSInteger)index
                    direction:(SCBrowseDirection)direction
                  browseStyle:(SCBrowseStyle)browseStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        _browseScrollviewArray = [[NSMutableArray alloc]init];
        _mediasArray = mediasArray;
        _fromRect = fromRect;
        _index = index;
        _direction = direction;
        _browseStyle = browseStyle;
        _showImageCount = _mediasArray.count >= 3 ? 3 : _mediasArray.count;
    }
    return self;
}
- (void)layoutSubviews
{
    self.backgroundColor = [UIColor blackColor];
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        
        CGFloat contentSizeWidth = _scrollView.bounds.size.width * (_direction ? 1 : _showImageCount);
        CGFloat contentSizeHeight = _scrollView.bounds.size.height * (_direction ? _showImageCount : 1);
        
        _scrollView.contentSize = CGSizeMake(contentSizeWidth , contentSizeHeight);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    [_browseScrollviewArray removeAllObjects];
    for (NSInteger i = 0; i < _showImageCount; i ++) {
        CGFloat originX = _scrollView.bounds.size.width * (_direction ? 0 : i);
        CGFloat originY = _scrollView.bounds.size.height * (_direction ? i : 0);
        CGFloat width = _scrollView.bounds.size.width;
        CGFloat height = _scrollView.bounds.size.height;
        
        SCBrowseScrollView *browseScrollView = [[SCBrowseScrollView alloc]initWithFrame:CGRectMake(originX, originY, width, height)
                                                                            browseStyle:_browseStyle];
        browseScrollView.backgroundColor = [UIColor clearColor];
        browseScrollView.browseDelegate = self;
        [_scrollView addSubview:browseScrollView];
        [_browseScrollviewArray addObject:browseScrollView];
    }
    if (_browseStyle == SCBrowseStyleSubView) {
        [self showScrollViewIndex:_index animate:NO];
    }else{
        [self showScrollViewIndex:_index animate:YES];
    }
}
///根据index调整scrollView
- (void)showScrollViewIndex:(NSInteger)index animate:(BOOL)animate
{
    [[SCImageBrowse defaulBrowse] refreshBrowseFooterViewWithIndex:index];

    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    if (index == 0) {
        offsetX = 0.0;
        offsetY = 0.0;
    }else if(index < _mediasArray.count - 1 || (_mediasArray.count == 2 && index == 1)){
        offsetX = _scrollView.bounds.size.width * (_direction ? 0 : 1);
        offsetY = _scrollView.bounds.size.height * (_direction ? 1 : 0);
    }else{
        offsetX = _scrollView.bounds.size.width * (_direction ? 0 : 2);
        offsetY = _scrollView.bounds.size.height * (_direction ? 2 : 0);
    }
    _scrollView.contentOffset = CGPointMake(offsetX, offsetY);
    NSLog(@"%@",_scrollView);
    
    [self refreshScrollViewImageWithMediaArray:[self showMediaArrayWithIndex:index] animate:animate];
}
///刷新显示的图片
- (void)refreshScrollViewImageWithMediaArray:(NSMutableArray *)mediaArray animate:(BOOL)animate
{
    for (NSInteger i = 0; i < _browseScrollviewArray.count; i ++) {
        SCBrowseScrollView *broseScrollView = _browseScrollviewArray[i];
        [broseScrollView setImageViewWith:mediaArray[i] fromRect:_fromRect animate:animate];
    }
}
///根据index计算显示mediaArray
- (NSMutableArray *)showMediaArrayWithIndex:(NSInteger)index
{
    NSMutableArray *showMediaArray = [[NSMutableArray alloc]init];
    if (_mediasArray.count <= 2) {
        return _mediasArray;
    }
    if (index == 0) {
        [showMediaArray addObjectsFromArray:[_mediasArray subarrayFromIndex:index count:3]];
    }else if(index < _mediasArray.count - 1){
        [showMediaArray addObjectsFromArray:[_mediasArray subarrayFromIndex:(index - 1) count:3]];
    }else{
        [showMediaArray addObjectsFromArray:[_mediasArray subarrayFromIndex:(index - 2) count:3]];
    }
    return showMediaArray;
}
///scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_delegate browseView:self didscrollView:scrollView];
    if ((_direction == 0 && !(lrint(scrollView.contentOffset.x) % lrint(_scrollView.bounds.size.width)))
        || (_direction == 1 && !(lrint(scrollView.contentOffset.y) % lrint(_scrollView.bounds.size.height)))) {
        //整张图片的时候触发
        NSInteger scrollIndex = 1;
        if (_direction) {
            scrollIndex = lrint(scrollView.contentOffset.y / _scrollView.bounds.size.height) ;
        }else{
            scrollIndex = lrint(scrollView.contentOffset.x / _scrollView.bounds.size.width) ;
        }
        if (scrollIndex == 2) {//左向右 上向下
            if (_index < _mediasArray.count - 1) {
                _index ++;
                [self showScrollViewIndex:_index animate:NO];
                [_delegate browseView:self ChangeIndex:_index];
                return;
            }
        }
        if (scrollIndex == 0) {//右向左 下向上
            if (_index > 0) {
                _index --;
                [self showScrollViewIndex:_index animate:NO];
                [_delegate browseView:self ChangeIndex:_index];
                return;
            }
        }
        if (scrollIndex ==1) {//滑动到边距
            if (_index == 0) {
                _index ++;
                [self showScrollViewIndex:_index animate:NO];
                [_delegate browseView:self ChangeIndex:_index];
                return;
            }
            if (_index == _mediasArray.count - 1) {
                if (_index > 1) {
                    _index --;
                    [self showScrollViewIndex:_index animate:NO];
                    [_delegate browseView:self ChangeIndex:_index];
                    return;
                }
            }
        }
    }
}
- (void)oneTapTouchBrowseScrollView
{
    if ([_delegate respondsToSelector:@selector(oneTapBrowseViewWithBrowseView:)]) {
        [_delegate oneTapBrowseViewWithBrowseView:self];
    }
}
- (void)longPressTouchBrowseScrollView
{
    [self createAcctionSheet];
}
- (void)createAcctionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到本地", nil];
    [actionSheet showInView:self];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"保存到本地"]) {
        [[SCImageBrowse defaulBrowse] saveImage:_mediasArray[_index]];
    }
}
@end
