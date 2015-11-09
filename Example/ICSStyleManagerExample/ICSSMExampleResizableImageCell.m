//
//  ICSSMExampleResizableImageCell.m
//  ICSStyleManagerExample
//
//  Created by Ludovico Rossi on 17/03/14.
//  Copyright (c) 2014 ice cream studios s.r.l. All rights reserved.
//

#import "ICSSMExampleResizableImageCell.h"
#import "ICSStyleManager.h"


@interface ICSSMExampleResizableImageCell ()

@property (nonatomic, readonly) UIButton *button;

@end


@implementation ICSSMExampleResizableImageCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:NSLocalizedString(@"Example Button", @"") forState:UIControlStateNormal];
        _button.titleLabel.font = [[ICSStyleManager sharedManager] fontForKey:@"tableView.resizableImageCell.button.text.font"];
        
        // set (resizable) background image and text color for the normal button state
        [_button setTitleColor:[[ICSStyleManager sharedManager] colorForKey:@"tableView.resizableImageCell.button.text.color.normal"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[[ICSStyleManager sharedManager] imageForKey:@"tableView.resizableImageCell.button.image.normal"] forState:UIControlStateNormal];
        
        // set (resizable) background image and text color for the highlighted button state
        [_button setTitleColor:[[ICSStyleManager sharedManager] colorForKey:@"tableView.resizableImageCell.button.text.color.highlighted"] forState:UIControlStateHighlighted];
        [_button setBackgroundImage:[[ICSStyleManager sharedManager] imageForKey:@"tableView.resizableImageCell.button.image.highlighted"] forState:UIControlStateHighlighted];
        
        [_button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_button];
    }
    
    return self;
}

- (void)dealloc {
    [_button removeTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat kButtonMargin = [[ICSStyleManager sharedManager] floatForKey:@"tableView.resizableImageCell.button.margin"];
    self.button.frame = CGRectMake(kButtonMargin, kButtonMargin,
                                   self.bounds.size.width - (2.0f * kButtonMargin),
                                   self.bounds.size.height - (2.0f * kButtonMargin));
}

- (void)tap {
    if (self.didTapButton) {
        self.didTapButton();
    }
}

@end
