//
//  THRMediaCollectionViewCell.m
//  Through
//
//  Created by Renzo Crisóstomo on 02/06/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "THRMediaCollectionViewCell.h"
#import "THRLabel.h"

@interface THRMediaCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *opaqueBackground;
@property (nonatomic, weak) UIPageControl *pageControl;

- (void)setupContents;
- (void)changePage:(id)sender;

@end

@implementation THRMediaCollectionViewCell

#pragma mark - View Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContents];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [self.pageControl setCurrentPage:0];
}

#pragma mark - Private Methods

- (void)setupContents
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                            self.bounds.origin.y,
                                                            self.bounds.size.width,
                                                            self.bounds.size.height)];
    view.backgroundColor = [UIColor colorWithHexString:@"#000000"
                                                 alpha:0.75];
    view.alpha = 0;
    [self addSubview:view];
    self.opaqueBackground = view;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                                              self.bounds.origin.y,
                                                                              self.bounds.size.width,
                                                                              self.bounds.size.height)];
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(self.bounds.size.width * 2, self.bounds.size.height);
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    THRLabel *lblDescription = [[THRLabel alloc] initWithFrame:CGRectMake(self.bounds.size.width,
                                                                          self.bounds.origin.y,
                                                                          self.bounds.size.width,
                                                                          self.bounds.size.height - 36)];
    lblDescription.backgroundColor = [UIColor clearColor];
    lblDescription.textColor = [UIColor whiteColor];
    lblDescription.numberOfLines = 0;
    lblDescription.font = [UIFont systemFontOfSize:14.0f];
    lblDescription.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:lblDescription];
    self.lblDescription = lblDescription;
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                                                 self.bounds.size.height - 36,
                                                                                 self.bounds.size.width, 36)];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = 2;
    [pageControl addTarget:self
                    action:@selector(changePage:)
          forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)changePage:(id)sender
{
    NSInteger page = self.pageControl.currentPage;
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds
                                animated:YES];
}

#pragma mark - Public Methods

- (void)setImageURL:(NSURL *)imageURL
{
    [self.imgViewMedia setImageWithURL:imageURL
                      placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    _imageOffset = imageOffset;
    CGRect frame = self.imgViewMedia.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.imgViewMedia.frame = offsetFrame;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    float alpha = (320 - scrollView.contentOffset.x) / 320;
    alpha = (alpha < 0 ? 0 : alpha > 1 ? 1 : alpha);
    self.opaqueBackground.alpha = 1 - alpha;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

@end
