//
//  ICSSMExampleImageCell.m
//  ICSStyleManagerExample
//
//  Created by Ludovico Rossi on 17/03/14.
//  Copyright (c) 2014 ice cream studios s.r.l. All rights reserved.
//

#import "ICSSMExampleImageCell.h"
#import "ICSStyleManager.h"


@implementation ICSSMExampleImageCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        self.imageView.image = [[ICSStyleManager sharedManager] imageForKey:@"tableView.imageCell.image"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat kImageMargin = [[ICSStyleManager sharedManager] floatForKey:@"tableView.imageCell.imageMargin"];
    self.imageView.frame = CGRectMake(kImageMargin, kImageMargin,
                                      self.bounds.size.width - (2.0f * kImageMargin),
                                      self.bounds.size.height - (2.0f * kImageMargin));
}

@end
