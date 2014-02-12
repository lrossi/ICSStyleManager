//
//  NSRegularExpression+ICSRegEx.m
//  ICSStyleManager
//
//  Created by Ludovico Rossi on 04/09/12.
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

#import "NSRegularExpression+ICSRegEx.h"


@implementation NSRegularExpression (ICSRegEx)

+ (NSArray *)ics_capturedSubstringsWithFirstMatchOfPattern:(NSString *)pattern inString:(NSString *)string {
    NSParameterAssert(pattern);
    NSParameterAssert(string);
    
    NSMutableArray *capturedSubstrings = [[NSMutableArray alloc] init];
    NSParameterAssert(capturedSubstrings);
    
    // create regular expression
    NSError *error = nil;
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:&error];
    if (error != nil) {
        NSLog(@"[ICSRegEx]: Error creating regular expression: %@", error);
        return capturedSubstrings;
    }
    
    // obtain the first match of the regex pattern in the given string (if any)
    NSTextCheckingResult *match = [expression firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (match == nil || match.numberOfRanges <= 1) {
        // no matches for capturing subexpression (as described in the NSTextCheckingResult documentation,
        // the captured substring ranges are returned by -[NSTextCheckingResult rangeAtIndex:] with
        // indexes starting from 1).
        return capturedSubstrings;
    }
    
    NSUInteger count = match.numberOfRanges;
    for (NSUInteger i = 1; i < count; i++) {
        // add each captured substring to the array
        NSRange capturedSubstringRange = [match rangeAtIndex:i];
        NSString *capturedSubstring = [string substringWithRange:capturedSubstringRange];
        [capturedSubstrings addObject:capturedSubstring];
    }
    
    return capturedSubstrings;
}

+ (BOOL)ics_pattern:(NSString *)pattern matchesInString:(NSString *)string {
    NSParameterAssert(pattern);
    NSParameterAssert(string);
    
    NSError *error = nil;
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:&error];
    if (error != nil) {
        NSLog(@"[ICSRegEx]: Error creating regular expression: %@,", error);
        return NO;
    }

    NSRange matchRange = [expression rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    return (matchRange.location != NSNotFound);
}

@end
