//
//  NSRegularExpression+ICSRegEx.h
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

#import <Foundation/Foundation.h>


/**
 The `ICSRegEx` category adds methods that facilitate parsing and extracting
 token substrings from an `NSString` given a certain regular expression pattern.
 */
@interface NSRegularExpression (ICSRegEx)


/** @name Matching Patterns */

/**
 Given a string to look into and a regular expression pattern containing
 one or more capturing subexpressions, returns an array of the
 substrings captured in the first match of the regular expression pattern.
 
 @param pattern The regular expression pattern containing one or more
                capturing subexpressions.
 @param string  The string to look into.
 
 @return An array of the substrings captured in the first match of the
         regular expression pattern. If there are no matches or if the
         given pattern contains no capturing subexpressions, the
         returned array is empty.
 */
+ (NSArray *)ics_capturedSubstringsWithFirstMatchOfPattern:(NSString *)pattern inString:(NSString *)string;


/**
 Checks whether the given regular expression pattern matches at least
 once in the given string.
 
 @param pattern The regular expression pattern to be tested for matching.
 @param string  The string to look into.
 
 @return `YES` if the given regular expression pattern matches at least
         once in the given string, `NO` otherwise.
 */
+ (BOOL)ics_pattern:(NSString *)pattern matchesInString:(NSString *)string;

@end
