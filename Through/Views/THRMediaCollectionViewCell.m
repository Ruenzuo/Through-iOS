//
//  THRMediaCollectionViewCell.m
//  Through
//
//  Created by Renzo Crisóstomo on 02/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRMediaCollectionViewCell.h"

@interface THRMediaCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imgViewMedia;

@end

@implementation THRMediaCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView
{
    self.clipsToBounds = YES;
    UIImageView *imgViewMedia = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(self.bounds.origin.x,
                                                          self.bounds.origin.y,
                                                          self.bounds.size.width,
                                                          IMAGE_HEIGHT)];
    imgViewMedia.backgroundColor = [UIColor redColor];
    imgViewMedia.contentMode = UIViewContentModeScaleAspectFill;
    imgViewMedia.clipsToBounds = NO;
    [self addSubview:imgViewMedia];
    self.imgViewMedia = imgViewMedia;
}

- (void)setImageURL:(NSURL *)imageURL
{
    //TODO: Set media URL.
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    _imageOffset = imageOffset;
    CGRect frame = self.imgViewMedia.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.imgViewMedia.frame = offsetFrame;
}

@end
