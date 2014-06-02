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

@property (nonatomic, strong, readwrite) NSURL *imageURL;
@property (nonatomic, assign, readwrite) CGPoint imageOffset;

@end
