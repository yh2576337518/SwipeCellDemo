//
//  SwipeCell.h
//  SwipeCellDemo
//
//  Created by 惠上科技 on 2018/9/14.
//  Copyright © 2018年 惠上科技. All rights reserved.
//

#import <UIKit/UIKit.h>
// 定义编辑文字可修改属性key
extern NSString *const SWIPCELL_FONT;
extern NSString *const SWIPCELL_TITLE;
extern NSString *const SWIPCELL_TITLECOLOR;
extern NSString *const SWIPCELL_BACKGROUNDCOLOR;
extern NSString *const SWIPCELL_IMAGE;


typedef NS_OPTIONS(NSUInteger, SwipeCellState) {
    SwipeCellStateHadClose   = 0,//默认全部闭合
    SwipeCellStateMoving    ,    //正在打开,或者正在关闭，手指还没有离开cell
    SwipeCellStateHadOpen   ,    //已经打开
};

@protocol SwipeCellDataSource , SwipeCellDelegate;
@interface SwipeCell : UITableViewCell
/**
 事件代理
 */
@property (nonatomic, weak) id<SwipeCellDelegate> swipeCellDelegate;

/**
 数据源代理
 */
@property (nonatomic, weak) id<SwipeCellDataSource> swipeCellDataSource;


/**
 当前cell的状态
 */
@property (nonatomic, assign, readonly) SwipeCellState state;


/**
 打开cell，如果有特殊需求可以调用，一般用不到
 
 @param animate 是否要动画
 */
- (void)open:(BOOL)animate;


/**
 关闭cell，如果有特殊需求可以调用，一般用不到
 
 @param animate 是否要动画
 */
- (void)close:(BOOL)animate;

@end



@protocol SwipeCellDataSource <NSObject>

@required

/**
 number of items
 
 @param swipeCell 当前cell
 @return count of items;
 */
- (int)numberOfItemsInSwipeCell:(SwipeCell *)swipeCell;

@optional

/**
 设置每个可操作的item都为button，设置好之后返回
 
 @param swipeCell cell
 @param index   位置自右往左，从0开始
 @return 设置好的item信息：包括字体、颜色、图片、背景色等
 key包括如下字段，根据需要设置
 extern const NSString *SWIPCELL_FONT;
 extern const NSString *SWIPCELL_TITLE;
 extern const NSString *SWIPCELL_TITLECOLOR;
 extern const NSString *SWIPCELL_BACKGROUNDCOLOR;
 extern const NSString *SWIPCELL_IMAGE;
 */
- (NSDictionary *)dispositionForSwipeCell:(SwipeCell *)swipeCell atIndex:(int)index;


/**
 设置每一项的宽度
 
 @param swipeCell cell
 @param index 位置自右往左，从0开始
 @return 宽度
 */
- (CGFloat)itemWithForSwipeCell:(SwipeCell *)swipeCell atIndex:(int)index;
@end



/**
 cell 的事件代理
 */
@protocol SwipeCellDelegate <NSObject>


/**
 是否开启左滑编辑功能
 
 @param swipeCell cell
 @param indexPath indexPath
 @return BOOL
 */
- (BOOL)swipeCellCanSwipe:(SwipeCell *)swipeCell atIndexPath:(NSIndexPath *)indexPath;

/**
 某一个item被点击后触发的事件
 
 @param swipeCell cell
 @param button button
 @param index 位置
 */
- (void)swipeCell:(SwipeCell *)swipeCell didSelectButton:(UIButton *)button atIndex:(int)index;


/**
 cell正在所有滑动，手指还没有离开，不确定是打开还是关闭
 
 @param swipeCell cell
 */
- (void)swipeCellMoving:(SwipeCell *)swipeCell;

/**
 当左滑打开后触发该事件
 
 @param swipeCell cell
 */
- (void)swipeCellHadOpen:(SwipeCell *)swipeCell;

/**
 cell优化打开时触发该事件
 
 @param swipeCell cell
 */
- (void)swipeCellHadClose:(SwipeCell *)swipeCell;
@end
