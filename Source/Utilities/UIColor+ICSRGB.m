//
//  UIColor+ICSRGB.m
//  ICSStyleManager
//
//  Created by Ludovico Rossi on 24/01/13.
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

#import "UIColor+ICSRGB.h"


@implementation UIColor (ICSRGB)

+ (UIColor *)ics_colorWithRGBValues:(ICSRGB)rgbValues {
    return [[self class] ics_colorWithRGBValues:rgbValues alpha:1.0f];
}

+ (UIColor *)ics_colorWithRGBValues:(ICSRGB)rgbValues alpha:(CGFloat)alpha {
    UIColor *color = [[self class] ics_colorWithRGBAValues:ICSRGBAMake(rgbValues.r, rgbValues.g, rgbValues.b, alpha)];
    NSParameterAssert(color);
    return color;
}

+ (UIColor *)ics_colorWithRGBAValues:(ICSRGBA)rgbaValues {
    UIColor *color = [[self class] colorWithRed:rgbaValues.r / 255.0f
                                          green:rgbaValues.g / 255.0f
                                           blue:rgbaValues.b / 255.0f
                                          alpha:rgbaValues.a];
    NSParameterAssert(color);
    return color;
}

@end


ICSRGB ICSRGBMake(unsigned short r, unsigned short g, unsigned short b) {
    return (ICSRGB) {r, g, b};
}

ICSRGBA ICSRGBAMake(unsigned short r, unsigned short g, unsigned short b, CGFloat a) {
    return (ICSRGBA) {r, g, b, a};
}
