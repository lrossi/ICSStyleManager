//
//  ICSSMExampleViewController.m
//  ICSStyleManagerExample
//
//  Created by Ludovico Rossi on 09/01/14.
//  Copyright (c) 2014 ice cream studios s.r.l. All rights reserved.
//

#import "ICSSMExampleViewController.h"
#import "ICSSMExampleViewCell.h"
#import "ICSSMExampleImageCell.h"
#import "ICSSMExampleResizableImageCell.h"
#import "ICSStyleManager.h"


typedef NS_ENUM(NSUInteger, ICSSMExampleSection) {
    ICSSMExampleLabel1Section = 0,
    ICSSMExampleLabel2Section,
    ICSSMExampleViewSection,
    ICSSMExampleImageSection,
    ICSSMExampleResizableImageSection,
    ICSSMExamplePatternImageSection,
    ICSSMExampleSectionCount
};


@implementation ICSSMExampleViewController

#pragma mark - Initialization

- (id)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    self.tableView.backgroundColor = [[ICSStyleManager sharedManager] colorForKey:@"tableView.backgroundColor"];
    self.navigationItem.title = NSLocalizedString(@"Style Manager Demo", @"");
    
    // this button is added to show the default window's tint color
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ICSSMExampleSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // each section has only one row
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const ICSSMExampleLabelCellIdentifier = @"ICSSMExampleLabelCellIdentifier";
    static NSString *const ICSSMExampleViewCellIdentifier = @"ICSSMExampleViewCellIdentifier";
    static NSString *const ICSSMExampleImageCellIdentifier = @"ICSSMExampleImageCellIdentifier";
    static NSString *const ICSSMExampleResizableImageCellIdentifier = @"ICSSMExampleResizableImageCellIdentifier";
    static NSString *const ICSSMExamplePatternImageCellIdentifier = @"ICSSMExamplePatternImageCellIdentifier";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == ICSSMExampleLabel1Section || indexPath.section == ICSSMExampleLabel2Section) {
        // load label cell
        cell = [self.tableView dequeueReusableCellWithIdentifier:ICSSMExampleLabelCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ICSSMExampleLabelCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        // set label's font and text
        NSString *const labelFontKey = (indexPath.section == ICSSMExampleLabel1Section ? @"tableView.label1Cell.font" : @"tableView.label2Cell.font");
        cell.textLabel.font = [[ICSStyleManager sharedManager] fontForKey:labelFontKey];
        cell.textLabel.textColor = [[ICSStyleManager sharedManager] colorForKey:@"mainColor.foreground"];
        cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Label %lu", @""), indexPath.section+1];
    }
    else if (indexPath.section == ICSSMExampleViewSection) {
        // load view cell
        cell = [self.tableView dequeueReusableCellWithIdentifier:ICSSMExampleViewCellIdentifier];
        if (cell == nil) {
            cell = [[ICSSMExampleViewCell alloc] initWithReuseIdentifier:ICSSMExampleViewCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else if (indexPath.section == ICSSMExampleImageSection) {
        // load image cell
        cell = [self.tableView dequeueReusableCellWithIdentifier:ICSSMExampleImageCellIdentifier];
        if (cell == nil) {
            cell = [[ICSSMExampleImageCell alloc] initWithReuseIdentifier:ICSSMExampleImageCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else if (indexPath.section == ICSSMExampleResizableImageSection) {
        // load image cell
        cell = [self.tableView dequeueReusableCellWithIdentifier:ICSSMExampleResizableImageCellIdentifier];
        if (cell == nil) {
            cell = [[ICSSMExampleResizableImageCell alloc] initWithReuseIdentifier:ICSSMExampleResizableImageCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            __weak typeof(self) weakSelf = self;
            ICSSMExampleResizableImageCell *exampleResizableImageCell = ((ICSSMExampleResizableImageCell *)cell);
            
            exampleResizableImageCell.didTapButton = ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"`Example Button` tapped", @"") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:nil]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            };
        }
    }
    else if (indexPath.section == ICSSMExamplePatternImageSection) {
        // load pattern image cell
        cell = [self.tableView dequeueReusableCellWithIdentifier:ICSSMExamplePatternImageCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ICSSMExamplePatternImageCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backgroundColor = [[ICSStyleManager sharedManager] colorForKey:@"tableView.patternCell.backgroundColor"];
    }
    
    if (indexPath.section != ICSSMExamplePatternImageSection) {
        cell.backgroundColor = [[ICSStyleManager sharedManager] colorForKey:@"tableView.cellBackgroundColor"];
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ICSSMExampleViewSection) {
        return [[ICSStyleManager sharedManager] floatForKey:@"tableView.viewCell.height"];
    }
    else if (indexPath.section == ICSSMExampleImageSection) {
        return [[ICSStyleManager sharedManager] floatForKey:@"tableView.imageCell.height"];
    }
    else if (indexPath.section == ICSSMExampleResizableImageSection) {
        return [[ICSStyleManager sharedManager] floatForKey:@"tableView.resizableImageCell.height"];
    }
    
    return [[ICSStyleManager sharedManager] floatForKey:@"tableView.defaultCellHeight"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[ICSStyleManager sharedManager] floatForKey:@"tableView.header.height"];
}

- (NSString *)textForHeaderInSection:(NSInteger)section {
    if (section == ICSSMExampleLabel1Section) {
        return NSLocalizedString(@"Example Label 1", @"");
    }
    else if (section == ICSSMExampleLabel2Section) {
        return NSLocalizedString(@"Example Label 2", @"");
    }
    else if (section == ICSSMExampleViewSection) {
        return NSLocalizedString(@"Example View", @"");
    }
    else if (section == ICSSMExampleImageSection) {
        return NSLocalizedString(@"Example Image", @"");
    }
    else if (section == ICSSMExampleResizableImageSection) {
        return NSLocalizedString(@"Example Resizable Image", @"");
    }
    else if (section == ICSSMExamplePatternImageSection) {
        return NSLocalizedString(@"Example Pattern Image", @"");
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    const CGRect kHeaderViewFrame = CGRectMake(0.0f, 0.0f,
                                               self.tableView.bounds.size.width,
                                               [[ICSStyleManager sharedManager] floatForKey:@"tableView.header.height"]);
    
    UIView *headerView = [[UIView alloc] initWithFrame:kHeaderViewFrame];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectInset(kHeaderViewFrame,
                                                                      [[ICSStyleManager sharedManager] floatForKey:@"tableView.header.sideMargin"], 0.0f)];
    
    headerLabel.backgroundColor = self.tableView.backgroundColor;
    headerLabel.textColor = [[ICSStyleManager sharedManager] colorForKey:@"tableView.header.textColor"];
    headerLabel.font = [[ICSStyleManager sharedManager] fontForKey:@"tableView.header.font"];
    headerLabel.text = [[self textForHeaderInSection:section] uppercaseString];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

#pragma mark - Done Button

- (void)done {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"`Done` button tapped", @"") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
