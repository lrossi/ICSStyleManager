//
//  ICSSMExampleResizableImageCell.h
//  ICSStyleManagerExample
//
//  Created by Ludovico Rossi on 17/03/14.
//  Copyright (c) 2014 ice cream studios s.r.l. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICSSMExampleResizableImageCell : UITableViewCell

@property (copy, nonatomic) void (^didTapButton)();

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
