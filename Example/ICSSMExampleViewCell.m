//
//  ICSSMExampleViewCell.m
//  ICSStyleManagerExample
//
//  Created by Ludovico Rossi on 17/01/14.
//  Copyright (c) 2014 ice cream studios s.r.l. All rights reserved.
//

#import "ICSSMExampleViewCell.h"
#import "ICSStyleManager.h"


@interface ICSSMExampleViewCell ()

@property (nonatomic, readonly) UIView *square1View;
@property (nonatomic, readonly) UIView *square2View;

@end


@implementation ICSSMExampleViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        _square1View = [[UIView alloc] init];
        _square1View.backgroundColor = [[ICSStyleManager sharedManager] colorForKey:@"tableView.viewCell.square1.color"];
        [self addSubview:_square1View];
        
        _square2View = [[UIView alloc] init];
        _square2View.backgroundColor = [[ICSStyleManager sharedManager] colorForKey:@"tableView.viewCell.square2.color"];
        [self addSubview:_square2View];
        
        const CGPoint kSquare1Position = [[ICSStyleManager sharedManager] pointForKey:@"tableView.viewCell.square1.position"];
        const CGPoint kSquare2Position = [[ICSStyleManager sharedManager] pointForKey:@"tableView.viewCell.square2.position"];
        const CGFloat kSquare1Width = [[ICSStyleManager sharedManager] floatForKey:@"tableView.viewCell.square1.width"];
        const CGFloat kSquare2Width = [[ICSStyleManager sharedManager] floatForKey:@"tableView.viewCell.square2.width"];
        const CGFloat kSquareHeight = [[ICSStyleManager sharedManager] floatForKey:@"tableView.viewCell.squareHeight"];
        
        _square1View.frame = CGRectMake(kSquare1Position.x, kSquare1Position.y, kSquare1Width, kSquareHeight);
        _square2View.frame = CGRectMake(kSquare2Position.x, kSquare2Position.y, kSquare2Width, kSquareHeight);
    }
    
    return self;
}

@end
