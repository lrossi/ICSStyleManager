//
//  UIColor+ICSRGB.h
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

#import <UIKit/UIKit.h>


/**
 Struct that represents a color in RGB coordinates.
 */
typedef struct {
    unsigned short r;
    unsigned short g;
    unsigned short b;
} ICSRGB;


/**
 Struct that represents a color with alpha component in RGBA
 coordinates.
 */
typedef struct {
    unsigned short r;
    unsigned short g;
    unsigned short b;
    CGFloat a;
} ICSRGBA;


/**
 The `ICSRGB` category adds easy `UIColor` instance creation
 given *RGB* and *RGBA* values.
 */
@interface UIColor (ICSRGB)


/** @name Creating Colors */

/**
 Returns a color created with the given RGB components. The alpha
 component of the new color is set to `1.0`.
 
 @param rgbValues The RGB components of the new color.
 
 @return A color created with the given RGB components.
 */
+ (UIColor *)ics_colorWithRGBValues:(ICSRGB)rgbValues;


/**
 Returns a color created with the given RGB and alpha components.
 
 @param rgbValues The RGB components of the new color.
 @param alpha     The alpha component of the new color.
 
 @return A color created with the given RGB and alpha components.
 */
+ (UIColor *)ics_colorWithRGBValues:(ICSRGB)rgbValues alpha:(CGFloat)alpha;


/**
 Returns a color created with the given RGBA components. This
 is equivalent to calling +ics_colorWithRGBValues:alpha: and passing
 `rgbaValues.a` as `alpha` parameter.
 
 @param rgbaValues The RGBA components of the new color.
 
 @return A color created with the given RGBA components.
 
 @see +ics_colorWithRGBValues:alpha:
 */
+ (UIColor *)ics_colorWithRGBAValues:(ICSRGBA)rgbaValues;

@end


/**
 Creates an `ICSRGB` struct to be passed to the UIColor(ICSRGB)
 category's methods
 
 @param r The R color component.
 @param g The G color component.
 @param b The B color component.
 
 @return A `ICSRGB` struct created with the given RGB components.
 */
extern ICSRGB ICSRGBMake(unsigned short r, unsigned short g, unsigned short b);


/**
 Creates an `ICSRGBA` struct to be passed to the UIColor(ICSRGB)
 category's methods
 
 @param r The R color component.
 @param g The G color component.
 @param b The B color component.
 @param a The alpha color component.
 
 @return A `ICSRGBA` struct created with the given RGBA components.
 */
extern ICSRGBA ICSRGBAMake(unsigned short r, unsigned short g, unsigned short b, CGFloat a);
