//
//  THRMediaCollectionViewCell.h
//  Through
//
//  Created by Renzo Crisóstomo on 02/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_HEIGHT 200
#define IMAGE_OFFSET_SPEED 25

@interface THRMediaCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGPoint imageOffset;
@property (nonatomic, weak) UIImageView *imgViewMedia;
@property (nonatomic, weak) UILabel *lblDescription;

@end
