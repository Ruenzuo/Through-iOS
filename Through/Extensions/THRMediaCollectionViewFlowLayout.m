//
//  THRMediaCollectionViewFlowLayout.m
//  Through
//
//  Created by Renzo Crisóstomo on 02/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRMediaCollectionViewFlowLayout.h"

@implementation THRMediaCollectionViewFlowLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 10;
        self.itemSize = CGSizeMake(320, 160);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

@end
