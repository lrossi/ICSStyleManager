//
//  ICSStyleManager.h
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

#import <UIKit/UIKit.h>


@protocol ICSStyleManagerImageLoader;


/**
 The `ICSStyleManager` class parses and loads a style from an external
 file bundled within the app, and provides methods to retrieve values
 matching specific keys defined in the *style file*.
 
 ### Loading a Style
 
 Tipically there is no need to instantiate `ICSStyleManager` directly,
 since you can use the *Shared Manager* to load a style into the app.
 For example, assuming there is a file named *Example.style* in the
 app's Bundle Resources, that *style file* can be loaded by writing:
 
    [[ICSStyleManager sharedManager] loadStyle:@"Example"];
 
 A good place to load a *style file* is in the app delegate's
 `application:didFinishLaunchingWithOptions:` method, so that the 
 style will become accessible from all the other app's components.
 
 There is no need to explicitly initialize the *Shared Manager*
 singleton, since it will automatically be initialized the first time
 `sharedManager` is called.
 
 ### Accessing Style's Values
 
 Once a style has been loaded, each value defined in the style can be
 retrieved by passing the corresponding key to the `ICSStyleManager`'s
 method that matches the type of the value. For example, the style's
 numeric value defined with key `height` can be retrieved by writing:
    
    CGFloat height = [[ICSStyleManager sharedManager] floatForKey:@"height"];
 
 #### Groups of Values
 
 A style can define a group of semantically related values to be
 labelled with a common group name. To retrieve a value that has been
 defined inside a group, pass the string
 *\<group name>.\<value key>* as key to the `ICSStyleManager`
 instance. For example, the style's value defined with key `width`
 inside the group `table` can be retrieved by writing:
 
    CGFloat width = [[ICSStyleManager sharedManager] floatForKey:@"table.width"];
 
 `ICSStyleManager` also supports nested groups: in that case, the full
 key path for a specific value is composed by separating each group
 name with a dot, ending the sequence with the value's key. For example,
 the style's value defined with key `backgroundColor` inside the group
 `header` nested inside the group `mainView` can be retrieved by writing:
 
    UIColor *backgroundColor = [[ICSStyleManager sharedManager] floatForKey:@"mainView.header.backgroundColor"];
 
 ### Defining a Style
 
 A style is defined in a simple plain text file with `UTF-8` encoding.
 The `.style` extension is required by `ICSStyleManager` to properly
 recognize a text file as a *style file*.
 
 Each style's value is defined in a separate line of the *style file*.
 You can get an idea of the style's syntax and most common supported
 types by looking at the following snippet:
 
    // define a numeric value of 10
    numberValue = #(10)
    
    // define numeric value of 40
    calculatedNumberValue = #(100 / 2.5)
    
    // define a UIFont value with name "Avenir-Book" and size 24 points
    fontValue = FONT (Avenir-Book, 24)
    
    // define a UIColor value expressed in RGB coordinates
    colorValue = %(244, 248, 251)
    
    // define a CGRect value corresponding to CGRectMake(10, 10, 44, 44)
    rectValue = R (10, 10, 44, 44)
 
    // define a UIImage value by loading an image from the app's bundle
    // resources
    imageValue = IMAGE (example_image)
 
 The following sections describe each of the supported types and
 syntaxes with greater detail.
 
 #### Numeric Values
 
 Numeric values can be defined in a *style file* with the syntax
 `#(<numeric value>)`, where:
 
 -  The *numeric value* can be written as integer, floating-point
    number or [numerical expression](#numerical-expressions).
 
 #### Font Values
 
 Font (i.e. `UIFont`) values can be defined in a *style file* with
 either the syntax `FONT(<font name>, <font size>)` or `FONT(<style of
 preferred font>)`, where:
 
 -  The *font name* is the fully specified name of the font as you
    would pass it to `[UIFont fontWithName:size:]` (for a comprehensive
    list of iOS font names see http://iosfonts.com).
 
 -  The *font size* can be written as integer, floating-point number
    or [numerical expression](#numerical-expressions).
 
 -  The *style of preferred font* maps to iOS 7's
    `[UIFont preferredFontForTextStyle:]`, so that you can write as
    *style of preferred font* one of these strings: `Headline`,
    `Subheadline`, `Body`, `Footnote`, `Caption1` or `Caption2`
    (for example, `FONT (Headline)`).
 
 #### Color Values
 
 Color (i.e. `UIColor`) values can be defined in a *style file* with
 the syntaxes `%(r, g, b)`, `%(r, g, b, a)`, `%(gray)` or
 `%(pattern_image)`, where:
 
 -  *r*, *g* and *b* are color components written as integer numbers
    in range between `0` and `255`.
 
 -  *a* is the alpha component written as a floating-point number in
    range between `0.0` and `1.0`.
 
 -  *gray* is a gray color component (*r*=*g*=*b*) written as integer
    number in range between `0` and `255`.
 
 -  *pattern_image* is the name of an image that `ICSStyleManager`
    will pass to `++[UIColor colorWithPatternImage:]` to construct
    the `UIColor`value. The image will be loaded according to the
    same policy used for [image values](#image-values).
 
 <div class="warning"> <strong>Warning:</strong>
 <a href="#numerical-expressions">Numerical expressions</a> are not
 currently supported for the <em>r</em>, <em>g</em>, <em>b</em>,
 <em>a</em> and <em>gray</em> color components.
 <a href="#variables">Variables</a> are not currently supported
 in place of a <em>pattern_image</em> name.</div>
 
 #### Rect Values
 
 Rect (i.e. `CGRect`) values can be defined in a *style file* with
 the syntax `R(x, y, width, height)`, where:
 
 -  *x*, *y*, *width* and *height* are the values you would pass to
    `CGRectMake()` and can be written as integers, floating-point
    numbers or [numerical expressions](#numerical-expressions).
 
 #### Size Values
 
 Size (i.e. `CGSize`) values can be defined in a *style file* with
 the syntax `S(width, height)`, where:
 
 -  *width* and *height* are the values you would pass to `CGSizeMake()`
    and can be written as integers, floating-point  numbers or
    [numerical expressions](#numerical-expressions).
 
 #### Point Values
 
 Point (i.e. `CGPoint`) values can be defined in a *style file* with
 the syntax `P(x, y)`, where:
 
 -  *x* and *y* are the values you would pass to `CGPointMake()` and
    can be written as integers, floating-point numbers or
    [numerical expressions](#numerical-expressions).
 
 ### <a id="image-values"></a>Image Values
 
 Image (i.e. `UIImage`) values can be defined in a *style file* with
 either the syntax `IMAGE(<image name>)` or `IMAGE(<image name>,
 <top cap inset>, <left cap inset>, <bottom cap inset>, <right cap
 inset>)`, where:
 
 -  The *image name* is the name of the image to be loaded. By
    default, `ICSStyleManager` uses `++[UIImage imageNamed:]` to
    load the image from the app's bundle resources. You can override
    this behavior by specifying an imageLoader.
    <div class="warning">In order to avoid preventive waste of
    memory, the actual image loading only occurs when
    `ICSStyleManager` is sent the message imageForKey: for the
    appropriate key.</div>
 
 -  *top cap inset*, *left cap inset*, *bottom cap inset* and *right
    cap inset* are the values you would pass to `UIEdgeInsetsMake()`
    and can be written as integers, floating-point numbers or
    [numerical expressions](#numerical-expressions). If you specify
    cap insets, `ICSStyleManager` will consider the image resizable
    and will construct the UIImage value through
    `--[UIImage resizableImageWithCapInsets:]`.
 
 #### <a id="numerical-expressions"></a> Numerical Expressions
 
 `ICSStyleManager` uses 
 [DDMathParser](https://github.com/davedelong/DDMathParser)
 to evaluate numerical expressions into numbers. Refer to the
 `DDMathParser` wiki for a comprehensive list of supported
 [operators](https://github.com/davedelong/DDMathParser/wiki/Operators)
 and
 [functions](https://github.com/davedelong/DDMathParser/wiki/Built-in-Functions).
 For example, `floor(5 / 2)` is a valid numerical expression that can
 be used in a *style file*.
 
 #### Groups of Values
 
 A style can define a group of semantically related values to be
 labelled with a common group name. A group of values can be defined
 in a *style file* by writing:
 
    <group name> {
        <value assignment 1>
        …
        <value assignment n>
    }
 
 as in the following example:
 
    titleLabel {
        backgroundColor = %(245)
        textColor = %(70)
    }
 
 <div class="warning"> <strong>Warning:</strong> The opening curly bracket
 must be placed on the same line of the group name, and the closing curly
 bracked must be placed on a separate line (as in the example above). </div>
 
 Group of values can also be nested inside another group. See the
 *Example.style* file in the `ICSStyleManagerDemo` project for a concrete
 example of multiple nested groups.
 
 #### <a id="variables"></a> Variables
 
 A value that has been previosly assigned to a key can also be accessed by
 another assignment in the same *style file* by writing:
 
    <new key> = @<key name>
 
 In this way, the value previously assigned to the key `<key name>` will
 also be assigned to the key `<new key>`. In the `ICSStyleManager`'s
 terminology, `@<key name>` is called a *variable*. For example, by
 writing:
 
    defaultMargin = #(320 - 50)
    textMargin = @defaultMargin
 
 both keys `defaultMargin` and `textMargin` will be assigned the numeric
 value `270`.
 
 A key defined inside of a group can be referred to by specifing its full
 key path, where each group name is separated by a dot, as in the following
 example:
 
    screen {
        width = #(320)
    }
 
    view {
        width = @screen.width
    }
 
 <div class="warning"> <strong>Warning:</strong> Currently other keys
 must always be referred to by using their full key path, even if a key
 is defined inside the same group of values of the assignment that refers
 to it.</div>
 
 If the values assigned to the keys they refer to are numeric, variables
 can also be used inside [numerical expressions](#numerical-expressions),
 as in the following example:
 
    view {
        width = #(320)
    }
 
    defaultMargin = #(@view.width - 50)
 
 
 ### Overriding Values in Another Style
 
 `ICSStyleManager` supports loading more than one style with multiple
 calls to loadStyle:. If an additional style redefines a key that has
 already been defined by a previously loaded style, that key's value
 will be overridden by the new one defined in the additional style. For
 example, consider the following *style files*. *Example.style*, with
 content:
 
    view {
        height = #(500)
        width = #(320)
    }
 
 and *Example-iPad.style*, with content:
 
    view {
        width = #(768)
    }
 
 These *style files* can be loaded in the app by writing:
 
    [[ICSStyleManager sharedManager] loadStyle:@"Example"];
 
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[ICSStyleManager sharedManager] loadStyle:@"Example-iPad"];
    }
 
 In this case, the key `view.width` will have value `320` on the
 iPhone and `768` on the iPad, while the key `view.height` will have
 value `500` on both platforms.
 
 <div class="warning"> <strong>Warning:</strong> Currently,
 <a href="#variables">variables</a> in a <em>style file</em> are
 evaluated when loading the file. This means that, if an additional
 style overrides a variable, the new value for this variable will not
 be re-evaluated in assignments or 
 <a href="#numerical-expressions">numerical expressions</a> in
 previously loaded <em>style files</em>.</div>

 
 ### Error Handling
 
 Since `ICSStyleManager`'s styles are not supposed to be edited by
 app's end users, all issues are expected to be discovered during the
 app testing and QA phases. For this reason, `ICSStyleManager` uses
 `NSAssert`-ions with explanatory messages to report encountered
 errors when loading or accessing a style.
 
 <div class="warning"> <strong>Warning:</strong> Be sure to test
 all of the style's keys and values before shipping the app, since
 <code>NSAssert</code> will typically be disabled in release
 builds.</div>
 
 
 ### Enable Debug Logging
 
 Debug logging when loading a style (i.e. when calling loadStyle:)
 can be enabled by defining the `ICS_STYLE_MANAGER_LOG`
 preprocessor identifier.
 
 */
@interface ICSStyleManager : NSObject


/** @name Getting the Shared ICSStyleManager Instance */

/**
 Returns the shared style manager object.
 
 @return The shared file manager object. The object will be lazily
         istantiated the first time the method is called, then the
         method will always return the same object until app
         termination.
 
 */
+ (instancetype)sharedManager;


/** @name Loading Styles */

/**
 Loads a style from a style file into the style manager. Once a
 style has been loaded, the values it defines can be retrieved
 by passing the corresponding keys to the getter methods.
 Debug logging when loading a style can be enabled by defining
 the `ICS_STYLE_MANAGER_LOG` preprocessor identifier.
 
 @param styleName The name of the style to be loaded. The `.style`
                  extension will be appended to the style name
                  and then the manager will expect to find a
                  *style file* with such a name inside the app's
                  Bundle Resources.
 
 @see             loadStyle:fromBundle:
 */
- (void)loadStyle:(NSString *)styleName;

/**
 Loads a style from a style file into the style manager. Once a
 style has been loaded, the values it defines can be retrieved
 by passing the corresponding keys to the getter methods.
 Debug logging when loading a style can be enabled by defining
 the `ICS_STYLE_MANAGER_LOG` preprocessor identifier.

 @param styleName The name of the style to be loaded. The `.style`
                  extension will be appended to the style name.

 @param bundle    Custom bundle where *styleName* file is located.
                  Useful for libraries to have their stylesheets
                  inside their own Bundle Resources. In case a
                  style with the given name is not found inside
                  the given bundle, the manager will attempt to
                  load the style file from the app's main Bundle
                  Resources.
 
 @see             loadStyle:
*/
- (void)loadStyle:(NSString *)styleName fromBundle:(NSBundle *)bundle;

/** @name Getting Style Values */

/**
 Returns the floating-point number value associated with the
 specified key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The floating-point number associated with the
            specified key.
 
 @see       integerForKey:
 @see       unsignedIntegerForKey:
 @see       loadStyle:
 */
- (CGFloat)floatForKey:(NSString *)key;


/**
 Returns the `CGRect` value associated with the specified
 key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The `CGRect` value associated with the specified
            key.
 
 @see       loadStyle:
 */
- (CGRect)rectForKey:(NSString *)key;


/**
 Returns the `CGSize` value associated with the specified
 key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The `CGSize` value associated with the specified
            key.
 
 @see       loadStyle:
 */
- (CGSize)sizeForKey:(NSString *)key;


/**
 Returns the `CGPoint` value associated with the specified
 key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The `CGPoint` value associated with the specified
            key.
 
 @see       loadStyle:
 */
- (CGPoint)pointForKey:(NSString *)key;


/**
 Returns the `UIFont` value associated with the specified
 key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The `UIFont` value associated with the specified
            key.
 
 @see       loadStyle:
 */
- (UIFont *)fontForKey:(NSString *)key;


/**
 Returns the `UIImage` value associated with the specified
 key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The `UIImage` value associated with the specified
            key.
 
 @see       loadStyle:
 */
- (UIImage *)imageForKey:(NSString *)key;


/**
 Returns the `UIColor` value associated with the specified
 key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The `UIColor` value associated with the specified
            key.
 
 @see       loadStyle:
 */
- (UIColor *)colorForKey:(NSString *)key;


/**
 Returns the unsigned integer value associated with the
 specified key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The unsigned integer value associated with the
            specified key.
 
 @see       integerForKey:
 @see       loadStyle:
 */
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;


/**
 Returns the integer value associated with the specified key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The integer value associated with the specified
            key.
 
 @see       unsignedIntegerForKey:
 @see       loadStyle:
 */
- (NSInteger)integerForKey:(NSString *)key;


/**
 Returns the `NSTimeInterval` value associated with the
 specified key.
 
 @param key A key defined in a style previously loaded with
            loadStyle:.
 
 @return    The `NSTimeInterval` value associated with the
            specified key.
 
 @see       loadStyle:
 */
- (NSTimeInterval)timeIntervalForKey:(NSString *)key;


/** @name Managing the Image Loader */

/**
 The object that acts as image loader for all the images
 defined in the loaded style files. If this property is
 set to nil (which is the default value), `ICSStyleManager`
 will load images using `++[UIImage imageNamed:]`. The
 image loader object must adopt the
 ICSStyleManagerImageLoader protocol.
 */
@property (nonatomic, weak) id<ICSStyleManagerImageLoader> imageLoader;

@end


/**
 An object must adopt the `ICSStyleManagerImageLoader`
 protocol to be used as an image loader for `ICSStyleManager`.
 A custom image loader is used in case you need to override
 `ICSStyleManager`'s behavior that by default loads all the
 images using `++[UIImage imageNamed:]`. You may want to
 define a custom image loading behavior—for instance—to
 exclude `++[UIImage imageNamed:]`'s cache mechanic and
 possibly to use your own instead.
 
 */
@protocol ICSStyleManagerImageLoader <NSObject>

/**
 Asks the image loader to load an image.
 
 @param styleManager The style manager requesting to load
                     an image.
 
 @param imageName    The name of the image to load as
                     defined in a style file previously
                     loaded by the style manager.
 
 @return The loaded UIImage.
 */
- (UIImage *)styleManager:(ICSStyleManager *)styleManager imageNamed:(NSString *)imageName;

@end
