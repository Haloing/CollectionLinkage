//
//  NewsCollectionCell.m
//  NewsTablveiw
//
//  Created by Mac OS X on 2016/11/16.
//  Copyright © 2016年 Haooing. All rights reserved.
//

#import "NewsCollectionCell.h"
#import "TableViewController.h"

@implementation NewsCollectionCell{
    
    TableViewController *_tableviewController;
    
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    //创建tableview并添加
    _tableviewController = [[TableViewController alloc] init];
    
    _tableviewController.tableView.backgroundColor = [UIColor whiteColor];
    
    _tableviewController.tableView.frame = self.bounds;
    
    [self addSubview:_tableviewController.tableView];
}

@end
