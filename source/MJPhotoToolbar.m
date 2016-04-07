//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "MJPhotoToolbar.h"
#import "MJPhoto.h"

@interface MJPhotoToolbar () {
    // 显示页码
    UILabel *_indexLabel;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;

//    UIView *line = [UIView new];
//    [self addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self);
//        make.height.mas_equalTo(1);
//        make.top.equalTo(self.mas_top);
//    }];
//    line.backgroundColor = [UIColor lightGrayColor];

    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:14];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }

    // 保存图片按钮
    CGFloat btnWidth = 24;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save.png"] forState:UIControlStateNormal];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    [_saveImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.width.and.height.mas_equalTo(28);
    }];
}

- (void)saveImage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex {
    _currentPhotoIndex = currentPhotoIndex;

    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", (int) _currentPhotoIndex + 1, (int) _photos.count];

    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled = photo.image != nil && !photo.save;
    _saveImageBtn.hidden = !_showSaveBtn;
}

@end
