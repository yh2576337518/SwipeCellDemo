//
//  MyCellModel.h
//  SwipeCellDemo
//
//  Created by 惠上科技 on 2018/9/14.
//  Copyright © 2018年 惠上科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCellModel : NSObject
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) int unreadCount;
@property (nonatomic, assign) int itemCout;

/**
 是否置顶
 */
@property (nonatomic, assign) BOOL isTop;
@end
