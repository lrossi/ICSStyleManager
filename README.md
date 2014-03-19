# ICSStyleManager

ICSStyleManager is a lightweight iOS library that lets you handily separate your app's font, color and other UI-related values into style sheet files that are both easy to read and straightforward to write.

ICSStyleManager's main goals are *simplicity* and *effectiveness*:

- *Simplicity*, because we didn't want to bloat our own code too much for such a simple task, thus we kept ICSStyleManager minimal for easy code readability and maintenance.

- *Effectiveness*, because we designed ICSStyleManager to facilitate real-world use cases minimizing additional hassle.

We are using ICSStyleManager in our app [Stories](http://stories.icecreamstudios.com).


## Get a Taste

Assuming your app's Bundle Resources contain a file called *Example.style* with the following content:

	 // define a numeric value of 10
	 numberValue = #(10)
	 
	 // define numeric value of 40
	 calculatedNumberValue = #(100 / 2.5)
	 
	 // define a UIFont value with name "Avenir-Book" and size 24 points
	 fontValue = FONT (Avenir-Book, 24)
	 
	 // define a UIColor value expressed in RGB coordinates
	 colorValue = %(244, 248, 251)
	 
	 view {
	 	// define a CGRect value corresponding to CGRectMake(10, 10, 44, 44)
	 	frame = R (10, 10, 44, 44)
	 }
	 
The *style file* can be loaded in your app's code by writing:

```objc
	[[ICSStyleManager sharedManager] loadStyle:@"Example"];
```

Then the values it defines can be accessed in your app's code by writing:

```objc
	CGFloat numberValue = [[ICSStyleManager sharedManager] floatForKey:@"numberValue"];
	CGFloat calculatedNumberValue = [[ICSStyleManager sharedManager] floatForKey:@"calculatedNumberValue"];
	UIFont *fontValue = [[ICSStyleManager sharedManager] fontForKey:@"fontValue"];
	UIColor *colorValue = [[ICSStyleManager sharedManager] colorForKey:@"colorValue"];
	CGRect viewFrame = [[ICSStyleManager sharedManager] rectForKey:@"view.frame"];
```

ICSStyleManager's supported value are currently `UIFont` (including iOS 7's `+[UIFont preferredFontForTextStyle:]`), `UIColor` (including the alpha component), `CGFloat`, `CGSize`, `CGPoint`, `CGRect`, `NSUInteger`, `NSInteger` and `NSTimeInterval`.

Despite its minimal code base, ICSStyleManager also offers a few advanced features:

- *group of values* (that can also be nested);

- *variables* (i.e. the ability to reference to a previously defined value in the same style);

- *numerical expression* (thanks to the [DDMathParser](https://github.com/davedelong/DDMathParser) library);

- *style overriding*.


## More Informations

You can have a look at ICSStyleManager's full [documentation](https://github.com/icecreamstudios/ICSStyleManager/wiki/ICSStyleManager) or quickly learn how to use it by looking at the simple example included in this project.

ICSStyleManager's full reference documentation is built with [appledoc](http://gentlebytes.com/appledoc/), thus it can be easily imported into Xcode and [Dash](http://kapeli.com/dash). You can find it inside the project's *Documentation* folder or online in the [project wiki](https://github.com/icecreamstudios/ICSStyleManager/wiki/ICSStyleManager).


## Requirements

ICSStyleManager has been developed and tested on iOS 7 only, yet you should be able to use it also on previous iOS versions with minor hassles.

## Installing

1. Recursively clone ICSStyleManager's git repository on your Mac, e.g. type `git clone --recursive https://github.com/icecreamstudios/ICSStyleManager` in your terminal.

2. Drag the files and folders `Source/ICSStyleManager.h`, `Source/ICSStyleManager.m`, `Source/Utilities/` and `Source/Libraries/DDMathParser/DDMathParser/` into your Xcode's project files.

3. Happy styling!


## Hacking

Being ICSStyleManager minimal by design, it is easy to extend and hack to suit any particular need of your app. If there is any extension or fix you want to share with the community, feel free to fork and send a pull request.


### Building the Documentation

ICSStyleManager's documentation is built with [appledoc](http://gentlebytes.com/appledoc/). The documentation is available either inside the project's *Documentation* folder or in the [project wiki](https://github.com/icecreamstudios/ICSStyleManager/wiki/ICSStyleManager), thus there is usually no need to build the documentation by yourself. However, if you make changes to ICSStyleManager and want to update the documentation accordingly, you can generate ICSStyleManager's documentation as follows:

1. Install [appledoc](http://gentlebytes.com/appledoc/) at the default path on your Mac (`/usr/local/bin/appledoc`).

2. Open the *ICSStyleManagerExample.xcodeproj* Xcode project file and select the *ICSStyleManagerDocumentation* target.

3. Build the target: the build script will automatically install the new Docset in the proper location to be recognized by Xcode. If you use [Dash](http://kapeli.com/dash), be sure to rescan Docsets in the preferences to update ICSStyleManager's documentation.


## About

ICSStyleManager was built to be used in our app [Stories](http://stories.icecreamstudios.com), brought to you by Ludovico Rossi and Vito Modena at [ice cream studios](http://www.icecreamstudios.com) (also developers of [Writings for iPad](http://www.writingsapp.com) and [Remember the Tripod](http://rememberthetripod.icecreamstudios.com)).

You can drop us a line at [opensource@icecreamstudios.com](mailto:opensource@icecreamstudios.com).


## License

ICSStyleManager's source code is available under the [MIT license](LICENSE).
