//
//  MyTableViewCell.h
//  SwipeCellDemo
//
//  Created by 惠上科技 on 2018/9/14.
//  Copyright © 2018年 惠上科技. All rights reserved.
//

#import "SwipeCell.h"
#import "MyCellModel.h"

@interface MyTableViewCell : SwipeCell
@property (nonatomic, strong) MyCellModel *model;
@end
