//
//  MyTableViewController.m
//  SwipeCellDemo
//
//  Created by 惠上科技 on 2018/9/14.
//  Copyright © 2018年 惠上科技. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyTableViewCell.h"
#import "MyCellModel.h"
#import "SwipeCell.h"
@interface MyTableViewController ()<SwipeCellDelegate,SwipeCellDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyTableViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MySwipeCell-Demo";
    [self.tableView registerClass:[MyTableViewCell  class] forCellReuseIdentifier:@"MyTableViewCell"];
    
    [self loadData];
}

- (void)loadData
{
    for (int i = 0; i < 18; i++) {
        MyCellModel *model = [[MyCellModel alloc]init];
        model.headUrl = @"headImage";
        model.isTop = i < 3;
        model.name = [NSString stringWithFormat:@"lengningLN-%d",i];
        model.message = [NSString stringWithFormat:@"微笑生活🙂，热爱coding！带着笑笑走下去！"];
        model.unreadCount = i%4;
        model.itemCout = i%3+1;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    cell.swipeCellDelegate = self;
    cell.swipeCellDataSource = self;
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // LNCellModel *model = self.dataSource[indexPath.row];
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"tableView------>%@ , indexPath------->%@",tableView,indexPath);
}


#pragma mark - swipeCellDelegate && dataSource

- (BOOL)swipeCellCanSwipe:(SwipeCell *)swipeCell atIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (int)numberOfItemsInSwipeCell:(SwipeCell *)swipeCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeCell];
    MyCellModel *model = self.dataSource[indexPath.row];
    return model.itemCout;
}

/*
 const NSString *LNSWIPCELL_FONT = @"LNSwipeCell_Font";
 const NSString *LNSWIPCELL_TITLE = @"LNSwipeCell_title";
 const NSString *LNSWIPCELL_TITLECOLOR = @"LNSwipeCell_titleColor";
 const NSString *LNSWIPCELL_BACKGROUNDCOLOR = @"LNSwipeCell_backgroundColor";
 const NSString *LNSWIPCELL_IMAGE = @"LNSwipeCell_image";
 */
- (NSDictionary *)dispositionForSwipeCell:(SwipeCell *)swipeCell atIndex:(int)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeCell];
    MyCellModel *model = self.dataSource[indexPath.row];
    NSString *title = @"删除";
    UIColor *color = [UIColor redColor];
    if (index == 1) {
        title = model.unreadCount >0 ? @"标为已读":@"标为未读";
        color = [UIColor lightGrayColor];
    }else if (index == 2){
        title = model.isTop?@"取消置顶":@"置顶";
        color = [UIColor blueColor];
    }
    return @{
             SWIPCELL_FONT:[UIFont systemFontOfSize:13],
             SWIPCELL_TITLE:title,
             SWIPCELL_BACKGROUNDCOLOR:color
             };
}

- (CGFloat)itemWithForSwipeCell:(SwipeCell *)swipeCell atIndex:(int)index
{
    if (index == 0) {
        return 60;
    }else{
        return 85;
    }
}

- (void)swipeCell:(SwipeCell *)swipeCell didSelectButton:(UIButton *)button atIndex:(int)index
{
    NSLog(@"--%s--",__func__);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeCell];
    MyCellModel *model = self.dataSource[indexPath.row];
    if (index == 0) {
        //确认删除
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }else{
        //标为未读/标为已读
        if (index == 1) {
            if (model.unreadCount == 0) {
                model.unreadCount = 1;
            }else{
                model.unreadCount = 0;
            }
            MyTableViewCell *cell = (MyTableViewCell*)swipeCell;
            cell.model = model;
        }else{
            model.isTop = !model.isTop;
            [self.dataSource removeObject:model];
            if (model.isTop == YES) {
                [self.dataSource insertObject:model atIndex:0];
                [self.tableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }else{
                for (int i = 0; i < self.dataSource.count; i++) {
                    MyCellModel *itemModel = self.dataSource[i];
                    if (itemModel.isTop == NO) {
                        [self.dataSource insertObject:model atIndex:i];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        break;
                    }
                }
                [self.tableView reloadData];
            }
            return;
        }
    }
}


- (void)swipeCellMoving:(SwipeCell *)swipeCell{
    NSLog(@"--%s--",__func__);
}

- (void)swipeCellHadClose:(SwipeCell *)swipeCell {
    NSLog(@"--%s--",__func__);
}

- (void)swipeCellHadOpen:(SwipeCell *)swipeCell {
    NSLog(@"--%s--",__func__);
}


- (void)dealloc{
    NSLog(@"------->%s",__func__);
}
@end
