//
//  imageCell.m
//  images
//
//  Created by XG on 16/2/26.
//  Copyright (c) 2016年 com.lhs. All rights reserved.
//

#import "imageCell.h"

@implementation imageCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor purpleColor];
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        self.imgView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.imgView];
    }
    return self;
}

@end
