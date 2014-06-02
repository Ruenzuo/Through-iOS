//
//  THRMediaCollectionViewCell.m
//  Through
//
//  Created by Renzo Crisóstomo on 02/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRMediaCollectionViewCell.h"
#import "THRLabel.h"

@interface THRMediaCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imgViewMedia;

- (void)addBlurView;
- (void)removeBlurView;

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
    imgViewMedia.backgroundColor = [UIColor whiteColor];
    imgViewMedia.contentMode = UIViewContentModeScaleAspectFill;
    imgViewMedia.clipsToBounds = NO;
    [self addSubview:imgViewMedia];
    self.imgViewMedia = imgViewMedia;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (self.blurView) {
        [self.blurView removeFromSuperview];
    }
}

- (void)setImageURL:(NSURL *)imageURL
{
    [self.imgViewMedia setImageWithURL:imageURL];
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    _imageOffset = imageOffset;
    CGRect frame = self.imgViewMedia.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.imgViewMedia.frame = offsetFrame;
}

#pragma mark - Public Methods

- (void)toggleDetails
{
    if (self.blurView) {
        [self removeBlurView];
    } else {
        [self addBlurView];
    }
}

#pragma mark - Private Methods

- (void)addBlurView
{
    FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0,
                                                                        self.bounds.size.height,
                                                                        self.bounds.size.width,
                                                                        self.bounds.size.height/2)];
    [blurView setTintColor:[UIColor clearColor]];
    blurView.blurRadius = 40;
    self.blurView = blurView;
    [self addSubview:blurView];
    THRLabel *lblDetails = [[THRLabel alloc]
                            initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2)];
    lblDetails.text = self.details;
    lblDetails.font = [UIFont systemFontOfSize:13.0f];
    lblDetails.numberOfLines = 3;
    [lblDetails setTextColor:[UIColor colorWithHexString:@"#5856D6"]];
    [self.blurView addSubview:lblDetails];
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.blurView.frame = CGRectMake(0,
                                                          self.bounds.size.height/2,
                                                          self.bounds.size.width,
                                                          self.bounds.size.height/2);
                     }];
}

- (void)removeBlurView
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.blurView.frame = CGRectMake(0,
                                                          self.bounds.size.height,
                                                          self.bounds.size.width,
                                                          self.bounds.size.height/2);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self.blurView removeFromSuperview];
                         }
                     }];
}

@end
