//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import "MJPhoto.h"

@class MJPhotoToolbar;

@interface MJPhotoBrowser : NSObject <UIScrollViewDelegate>
// 所有的图片对象
@property(nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property(nonatomic, assign) NSUInteger currentPhotoIndex;
// 保存按钮
@property(nonatomic, assign) NSUInteger showSaveBtn;
@property(strong, nonatomic) MJPhotoToolbar *toolbar;

// 显示
- (void)show;

@end