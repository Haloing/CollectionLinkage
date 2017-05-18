//
//  TopLabel.m
//  NewsTablveiw
//
//  Created by Mac OS X on 2016/11/16.
//  Copyright © 2016年 Haooing. All rights reserved.
//

#import "TopLabel.h"

@implementation TopLabel

- (void)setScale:(float)scale{
    
    _scale = scale;
    
    //改变label的字体颜色
    self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1.0];
    
    float minScale = 1.0;
    float maxScale = 1.5;
    
    scale =minScale + (maxScale - minScale) * scale;
    
    self.transform = CGAffineTransformMakeScale(scale, scale);
    
}

@end
