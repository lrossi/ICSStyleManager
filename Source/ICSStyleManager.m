//
//  ICSStyleManager.m
//  ICSStyleManager
//
//  Created by Ludovico Rossi on 02/10/13.
//
//  Copyright (c) 2014 ice cream studios s.r.l. - http://icecreamstudios.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ICSStyleManager.h"
#import "NSRegularExpression+ICSRegEx.h"
#import "UIColor+ICSRGB.h"
#import "NSString+DDMathParsing.h"


// -------------------------
// Configuration
// -------------------------

// Extension of the style files (will automatically be added to the
// string passed to -loadFile:)
static NSString *const STOStyleFileExtension = @"style";

// All the lines beginning with this prefix will be treated as comments
static NSString *const STOStyleCommentPrefix = @"//";

// Character used to separate group names when composing the key path
// of a value nested into one or more groups. (In case you need to
// change this, you'll also need to update the regular expressions below
// to reflect the change.)
static NSString *const STOStyleGroupSeparator = @".";


// -------------------------
// Regular Expressions
// -------------------------

// Pattern that matches a value assignment (e.g. `key = value`)
static NSString *const STOStyleAssignmentPattern = @"\\A([\\w|\\d|\\.]*)\\s*=\\s*(.*)\\z";

// Pattern that matches a variable name (e.g. `@varName`)
static NSString *const STOStyleVariablePattern = @"\\A@([\\w|\\d|\\.]*)\\z";

// Pattern that matches a variable name (e.g. `@varName`) as a substring
// of a possibly longer string
static NSString *const STOStyleInnerVariablePattern = @"@([\\w|\\d|\\.]*)";

// Pattern that matches a number value (e.g. `#(10)`)
static NSString *const STOStyleNumberPattern = @"\\A#\\s*\\((.*)\\)\\z";

// Pattern that matches a r, g, b color value (e.g. `%(122, 200, 15)`)
static NSString *const STOStyleRGBColorPattern = @"\\A\\%\\s*\\(\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*\\)\\z";

// Pattern that matches a r, g, b, a color value (e.g. `%(122, 200, 15, 0.8)`)
static NSString *const STOStyleRGBAColorPattern = @"\\A\\%\\s*\\(\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9]{1,3})\\s*,\\s*([0-9.]+)\\s*\\)\\z";

// Pattern that matches a gray color value (e.g. `%(122)`)
static NSString *const STOStyleGrayColorPattern = @"\\A\\%\\s*\\(\\s*([0-9]{1,3})\\s*\\)\\z";

// Pattern that matches a pattern image color value (e.g. `%(pattern_image_name)`)
static NSString *const STOStylePatternImageColorPattern = @"\\A\\%\\s*\\(\\s*([\\w-.]*)\\s*\\)\\z";

// Pattern that matches a rect value (e.g. `R(10, 10, 150, 200)`)
static NSString *const STOStyleRectPattern = @"\\AR\\s*\\(\\s*(.*)\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*\\)\\z";

// Pattern that matches a point value (e.g. `P(10, 10)`)
static NSString *const STOStylePointPattern = @"\\AP\\s*\\(\\s*(.*)\\s*,\\s*(.*)\\s*\\)\\z";

// Pattern that matches a size value (e.g. `S(150, 200)`)
static NSString *const STOStyleSizePattern = @"\\AS\\s*\\(\\s*(.*)\\s*,\\s*(.*)\\s*\\)\\z";

// Pattern that matches a font value (e.g. `FONT(Avenir-Book, 24)`)
static NSString *const STOStyleFontPattern = @"\\AFONT\\s*\\(\\s*(.*)\\s*,\\s*([0-9.]+)\\s*\\)\\z";

// Pattern that matches a preferred font value (e.g. `FONT(Headline)`)
static NSString *const STOStylePreferredFontPattern = @"\\AFONT\\s*\\(\\s*(\\w*)\\s*\\)\\z";

// Pattern that matches an image value (e.g. `IMAGE(example_image)`)
static NSString *const STOStyleImagePattern = @"\\AIMAGE\\s*\\(\\s*([\\w-.]*)\\s*\\)\\z";

// Pattern that matches a resizable image with cap insets value (e.g. `IMAGE(example_image, 5, 5, 5, 5)`)
static NSString *const STOStyleResizableImagePattern = @"\\AIMAGE\\s*\\(\\s*([\\w.]*)\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*,\\s*(.*)\\s*\\)\\z";

// Pattern that matches the beginning of a group of values block (e.g. `groupName {`)
static NSString *const STOStyleOpenGroupPattern = @"\\A([\\w|\\d|\\.]*)\\s*\\{\\z";

// Pattern that matches the end of a group of values block (e.g. `}`)
static NSString *const STOStyleCloseGroupPattern = @"\\A\\}\\z";


// -------------------------
// Styles for Preferred Font
// -------------------------

// Strings to be used in a style file to describe a preferred font's text
// styles. These values match the ones recognized by [UIFont preferredFontForTextStyle:]

static NSString *const STOStylePreferredFontStyleHeadline = @"Headline";
static NSString *const STOStylePreferredFontStyleSubheadline = @"Subheadline";
static NSString *const STOStylePreferredFontStyleBody = @"Body";
static NSString *const STOStylePreferredFontStyleFootnote = @"Footnote";
static NSString *const STOStylePreferredFontStyleCaption1 = @"Caption1";
static NSString *const STOStylePreferredFontStyleCaption2 = @"Caption2";


// -------------------------
// Private Interface
// -------------------------

// Declaration of NSString category used to evaluate a numerical expression written
// as string into a NSNumber. The category is implemented at the bottom of this source file
@interface NSString (ICSStyleManager)
- (NSNumber *)sto_numberByEvaluatingStringWithStyleDescriptor:(NSDictionary *)styleDescriptor;
@end


// Declaration of a tiny class used to store the informations needed to defer the
// loading of an image defined in a style file
@interface ICSStyleImageDescriptor : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSValue *capInsets;
@end


@interface ICSStyleManager ()
// This dictionary holds the mapping between style keys and actual values
// as they are parsed
@property (nonatomic, readonly) NSMutableDictionary *styleDescriptor;
@end


// -------------------------
// Implementation
// -------------------------

@implementation ICSStyleManager


#pragma mark - Singleton

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    
    return sharedManager;
}


#pragma mark - Initialization

- (instancetype)init {
    if ((self = [super init])) {
        _styleDescriptor = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark - Style Loading

- (void)loadStyle:(NSString *)styleName {
    NSParameterAssert(styleName);

    // add style file extension to the style name
    NSString *stylePath = [[NSBundle mainBundle] pathForResource:styleName ofType:STOStyleFileExtension];
    // load the style file from the app bundle into an NSString
    NSError *error = nil;
    NSString *styleText = [[NSString alloc] initWithContentsOfFile:stylePath encoding:NSUTF8StringEncoding error:&error];
    NSAssert(styleText != nil, @"[ICSStyleManager]: Error loading style `%@`: %@", styleName, error);
    
    // separate the style text file into lines
    NSArray *styleTextLines = [styleText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSParameterAssert(styleTextLines);
    NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
    
    // this array is used as a stack to hold the current group of values while
    // we are parsing the style (empty array means no group)
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    [styleTextLines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
        // for each line of the style file
        
        // trim whitespaces
        line = [line stringByTrimmingCharactersInSet:whitespaceSet];
        
        // check for empty or comment line
        if ([line isEqualToString:@""] || [line hasPrefix:STOStyleCommentPrefix]) {
            // ignore empty or comment line
            return;
        }
        
        // check for the beginning of a group of values (e.g. `groupName {`)
        NSArray *match = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleOpenGroupPattern inString:line];
        if (match.count == 1) {
            // add the group name to the groups stack
            [groups addObject:match[0]];
            return;
        }
        
        // check for the end of a group of values (e.g. `}`)
        if ([NSRegularExpression ics_pattern:STOStyleCloseGroupPattern matchesInString:line]) {
            NSAssert(groups.count > 0, @"[ICSStyleManager]: Unmatched ending of a group of values");
            // remove the most inner group name from the stack
            [groups removeLastObject];
            return;
        }
        
        // assume this is the assigment of a value to a key
        NSArray *assignmentMatches = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleAssignmentPattern inString:line];
        NSAssert(assignmentMatches.count == 2, @"[ICSStyleManager]: Unrecognized command `%@`", line);
        
        // parse assignment
        NSString *keyName = assignmentMatches[0];
        NSString *value = assignmentMatches[1];
        [self parseAssignmentOfValue:value toKey:keyName withGroups:groups];
    }];
    
#if defined(ICS_STYLE_MANAGER_LOG)
    NSLog(@"[ICSStyleManager]: Style `%@` loaded:\n%@", styleName, self.styleDescriptor);
#endif
}

#pragma mark Parse Assignment

- (void)parseAssignmentOfValue:(NSString *)value toKey:(NSString *)keyName withGroups:(NSArray *)groups {
    NSParameterAssert(value);
    NSParameterAssert(keyName);
    NSParameterAssert(groups);
    
    id evaluatedValue = nil;
    
    if ((evaluatedValue = [self parseAssignmentOfVariable:value])
            || (evaluatedValue = [self parseAssignmentOfNumber:value])
            || (evaluatedValue = [self parseAssignmentOfColor:value])
            || (evaluatedValue = [self parseAssignmentOfCGValue:value])
            || (evaluatedValue = [self parseAssignmentOfFont:value])
            || (evaluatedValue = [self parseAssignmentOfImage:value])) {
        // value to be assigned has been evaluated
        
        if (groups.count > 0) {
            // build full key path taking groups into accout
            NSString *groupPrefix = [[groups componentsJoinedByString:STOStyleGroupSeparator] stringByAppendingString:STOStyleGroupSeparator];
            NSParameterAssert(groupPrefix);
            keyName = [groupPrefix stringByAppendingString:keyName];
            NSParameterAssert(keyName);
        }
        
        // assign evaluated value to the given key
        self.styleDescriptor[keyName] = evaluatedValue;
        return;
    }
    
    NSAssert(NO, @"[ICSStyleManager]: Attempt to assign unrecognized value `%@` to key `%@`", value, keyName);
}

- (id)parseAssignmentOfVariable:(NSString *)value {
    NSArray *capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleVariablePattern inString:value];
    if (capturedSubstrings.count == 1) {
        // obtain the value of the specified variable
        NSString *varName = capturedSubstrings[0];
        id varValue = self.styleDescriptor[varName];
        NSAssert(varValue, @"[ICSStyleManager]: Attempt to assign an undefined variable `%@`", varName);
        return varValue;
    }
    
    return nil;
}

- (id)parseAssignmentOfNumber:(NSString *)value {
    NSArray *capturedSubstrings =[NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleNumberPattern inString:value];
    if (capturedSubstrings.count == 1) {
        return [capturedSubstrings[0] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor];
    }
    
    return nil;
}

- (id)parseAssignmentOfColor:(NSString *)value {

    // test for RGB color
    NSArray *capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleRGBColorPattern inString:value];
    if (capturedSubstrings.count == 3) {
        int r = [capturedSubstrings[0] intValue];
        int g = [capturedSubstrings[1] intValue];
        int b = [capturedSubstrings[2] intValue];
        return [UIColor ics_colorWithRGBValues:ICSRGBMake(r, g, b)];
    }
    
    
    // test for RGBA color
    capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleRGBAColorPattern inString:value];
    if (capturedSubstrings.count == 4) {
        int r = [capturedSubstrings[0] intValue];
        int g = [capturedSubstrings[1] intValue];
        int b = [capturedSubstrings[2] intValue];
        float a = [capturedSubstrings[3] floatValue];
        return [UIColor ics_colorWithRGBAValues:ICSRGBAMake(r, g, b, a)];
    }

    
    // test for gray color
    capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleGrayColorPattern inString:value];
    if (capturedSubstrings.count == 1) {
        int gray = [capturedSubstrings[0] intValue];
        return [UIColor ics_colorWithRGBValues:ICSRGBMake(gray, gray, gray)];
    }
    
    
    // test for pattern image color
    capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStylePatternImageColorPattern inString:value];
    if (capturedSubstrings.count == 1) {
        NSString *patternImageName = capturedSubstrings[0];
        UIImage *patternImage = [self loadImageNamed:patternImageName];
        return [UIColor colorWithPatternImage:patternImage];
    }
    
    return nil;
}

- (id)parseAssignmentOfCGValue:(NSString *)value {
    
    // test for rect
    NSArray *capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleRectPattern inString:value];
    if (capturedSubstrings.count == 4) {
        CGRect rect = CGRectMake([[capturedSubstrings[0] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue],
                                 [[capturedSubstrings[1] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue],
                                 [[capturedSubstrings[2] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue],
                                 [[capturedSubstrings[3] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue]);
        return [NSValue valueWithCGRect:rect];
    }

    
    // test for point
    capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStylePointPattern inString:value];
    if (capturedSubstrings.count == 2) {
        CGPoint point = CGPointMake([[capturedSubstrings[0] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue],
                                    [[capturedSubstrings[1] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue]);
        return [NSValue valueWithCGPoint:point];
    }

    
    // test for size
    capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleSizePattern inString:value];
    if (capturedSubstrings.count == 2) {
        CGSize size = CGSizeMake([[capturedSubstrings[0] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue],
                                 [[capturedSubstrings[1] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue]);
        return [NSValue valueWithCGSize:size];
    }
    
    return nil;
}

- (id)parseAssignmentOfFont:(NSString *)value {
   
    // test for font
    NSArray *capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleFontPattern inString:value];
    if (capturedSubstrings.count == 2) {
        return [UIFont fontWithName:capturedSubstrings[0] size:[[capturedSubstrings[1] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue]];
    }
    
    
    // test for style of preferred font
    capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStylePreferredFontPattern inString:value];
    if (capturedSubstrings.count == 1) {
        NSString *preferredFontStyle = capturedSubstrings[0];
        NSString *textStyle = nil;
        if ([preferredFontStyle isEqualToString:STOStylePreferredFontStyleHeadline]) {
            textStyle = UIFontTextStyleHeadline;
        }
        else if ([preferredFontStyle isEqualToString:STOStylePreferredFontStyleSubheadline]) {
            textStyle = UIFontTextStyleSubheadline;
        }
        else if ([preferredFontStyle isEqualToString:STOStylePreferredFontStyleBody]) {
            textStyle = UIFontTextStyleBody;
        }
        else if ([preferredFontStyle isEqualToString:STOStylePreferredFontStyleFootnote]) {
            textStyle = UIFontTextStyleFootnote;
        }
        else if ([preferredFontStyle isEqualToString:STOStylePreferredFontStyleCaption1]) {
            textStyle = UIFontTextStyleCaption1;
        }
        else if ([preferredFontStyle isEqualToString:STOStylePreferredFontStyleCaption2]) {
            textStyle = UIFontTextStyleCaption2;
        }
        
        NSAssert(textStyle != nil, @"[ICSStyleManager]: Unrecognized text style for preferred font: `%@`", preferredFontStyle);
        return [UIFont preferredFontForTextStyle:textStyle];
    }
    
    return nil;
}

- (id)parseAssignmentOfImage:(NSString *)value {
    
    // test for image
    NSArray *capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleImagePattern inString:value];
    if (capturedSubstrings.count == 1) {
        ICSStyleImageDescriptor *imageDescriptor = [[ICSStyleImageDescriptor alloc] init];
        imageDescriptor.name = capturedSubstrings[0];
        return imageDescriptor;
    }
    
    
    // test for resizable image
    capturedSubstrings = [NSRegularExpression ics_capturedSubstringsWithFirstMatchOfPattern:STOStyleResizableImagePattern inString:value];
    if (capturedSubstrings.count == 5) {
        ICSStyleImageDescriptor *imageDescriptor = [[ICSStyleImageDescriptor alloc] init];
        imageDescriptor.name = capturedSubstrings[0];
        
        UIEdgeInsets capInsets = UIEdgeInsetsMake([[capturedSubstrings[1] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue],
                                                  [[capturedSubstrings[2] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue],
                                                  [[capturedSubstrings[3] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue],
                                                  [[capturedSubstrings[4] sto_numberByEvaluatingStringWithStyleDescriptor:self.styleDescriptor] floatValue]);
        
        imageDescriptor.capInsets = [NSValue valueWithUIEdgeInsets:capInsets];
        
        return imageDescriptor;
    }
    
    return nil;
}


#pragma mark - Access Values

- (CGFloat)floatForKey:(NSString *)key {
    NSNumber *value = [self valueOfType:[NSNumber class] forKey:key];
    return [value floatValue];
}

- (CGRect)rectForKey:(NSString *)key {
    NSValue *value = [self valueOfType:[NSValue class] forKey:key];
    return [value CGRectValue];
}

- (CGSize)sizeForKey:(NSString *)key {
    NSValue *value = [self valueOfType:[NSValue class] forKey:key];
    return [value CGSizeValue];
}

- (CGPoint)pointForKey:(NSString *)key {
    NSValue *value = [self valueOfType:[NSValue class] forKey:key];
    return [value CGPointValue];
}

- (UIFont *)fontForKey:(NSString *)key {
    return [self valueOfType:[UIFont class] forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key {
    ICSStyleImageDescriptor *imageDescriptor = [self valueOfType:[ICSStyleImageDescriptor class] forKey:key];
    
    // load image from descriptor
    UIImage *image = [self loadImageNamed:imageDescriptor.name];
    
    if (imageDescriptor.capInsets != nil) {
        // has cap insets => the image is resizable
        image = [image resizableImageWithCapInsets:[imageDescriptor.capInsets UIEdgeInsetsValue]];
        NSAssert(image != nil, @"[ICSStyleManager]: Unable to make image for key `%@` resizable", image);
    }
    
    return image;
}

- (UIColor *)colorForKey:(NSString *)key {
    return [self valueOfType:[UIColor class] forKey:key];
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key {
    NSNumber *value = [self valueOfType:[NSNumber class] forKey:key];
    return [value unsignedIntegerValue];
}

- (NSInteger)integerForKey:(NSString *)key {
    NSNumber *value = [self valueOfType:[NSNumber class] forKey:key];
    return [value integerValue];
}

- (NSTimeInterval)timeIntervalForKey:(NSString *)key {
    NSNumber *value = [self valueOfType:[NSNumber class] forKey:key];
    return [value doubleValue];
}

- (id)valueOfType:(Class)class forKey:(NSString *)key {
    NSParameterAssert(class);
    NSParameterAssert(key);
    id value = self.styleDescriptor[key];
    NSAssert(value != nil, @"[ICSStyleManager]: Undefined key `%@`", key);
    NSAssert([value isKindOfClass:class], @"[ICSStyleManager]: Value for key `%@` is not of type `%@`", key, NSStringFromClass(class));
    return value;
}

- (UIImage *)loadImageNamed:(NSString *)imageName {
    NSParameterAssert(imageName);
    
    UIImage *image;
    
    if (self.imageLoader != nil) {
        // ask image loader for the image with the given name
        image = [self.imageLoader styleManager:self imageNamed:imageName];
    }
    else {
        // no image loader, load the image with +[UIImage imageNamed:]
        image = [UIImage imageNamed:imageName];
    }
    
    NSAssert(image != nil, @"[ICSStyleManager]: Unable to load image named `%@`", imageName);
    return image;
}

@end


// -------------------------
// NSString Category
// -------------------------

#pragma mark - Evaluate Numerical Expression

@implementation NSString (ICSStyleManager)

- (NSNumber *)sto_numberByEvaluatingStringWithStyleDescriptor:(NSDictionary *)styleDescriptor {
    NSParameterAssert(styleDescriptor);
    
    NSString *stringToEvaluate = self;
    
    while (YES) {
        // build a regular expression to check for a variable match (e.g. `@varName`)
        NSError *error = nil;
        NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:STOStyleInnerVariablePattern options:0 error:&error];
        NSAssert(error == nil, @"[ICSStyleManager]: Error building regular expression to evaluate number in string `%@`: %@", stringToEvaluate, error);
        
        // check for a variable match in the string
        NSTextCheckingResult *match = [expression firstMatchInString:stringToEvaluate options:0 range:NSMakeRange(0, stringToEvaluate.length)];
        if (match == nil || match.numberOfRanges <= 1) {
            // no variables, evaluate the string using DDMathParser's numberByEvaluatingString
            return [stringToEvaluate numberByEvaluatingString];
        }
        
        // variable found, extract its name
        NSRange matchRange = [match rangeAtIndex:1];
        NSString *varName = [stringToEvaluate substringWithRange:matchRange];
        
        // obtain variable's value
        NSNumber *n = styleDescriptor[varName];
        NSParameterAssert(n);
        NSAssert([n isKindOfClass:[NSNumber class]], @"[ICSStyleManager]: Attempt to use variable `%@` inside the numerical expression `%@`, but the variable's value is not a number", varName, self);
        
        // replace the variable with its number value in the string to evaluate
        NSParameterAssert(matchRange.location > 0);
        matchRange.location--, matchRange.length++; // also replace the '@' sign just before the variable name
        stringToEvaluate = [stringToEvaluate stringByReplacingCharactersInRange:matchRange withString:[n stringValue]];
        
        // check for other variable matches
    }
}

@end


// -------------------------
// Image Descriptor
// -------------------------

#pragma mark - Image Descriptor

@implementation ICSStyleImageDescriptor
@end
