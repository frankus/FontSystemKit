# FontSystemKit

### Motivation

Using the `UIAppearance` system with `UILabel` fonts in iOS has always been kind of awkward. If you set a global appearance, it affects the font *size* (and weight) of all of the labels along with the typeface. You can work around this to some degree with (otherwise-unnecessary) appearance container superviews or view subclasses, but they add size and complexity to your code.

You also have to manually set a font size and weight for each text style, and then make sure to use `UIFontMetrics` so that your fonts scale when using Dynamic Type. 

With FontSystemKit, you can fix this, often in just one line of code. 

You create a single `FontSystem` object with your chosen font, and it can automatically create scalable fonts for each text style based on the size and weight of the corresponding system font. You can then set it globally on (nearly) all `UILabel` objects in your app using the appearance proxy. 

This package should be considered experimental. If you find something that can be improved, your pull requests are welcome!

## Creating and using a FontSystem object

A prerequisite for using package is that your app's labels are using system text styles (e.g. "body" or "headline"). 

### Basic Usage

The typical way to create a font system object is to pass in the base font name (e.g. "AmericanTypewriter") and the suffixes for any weights you want to use (e.g. "-Bold"). 

Then use `UILabel`'s appearance proxy to set the font system on all UILabels in your app. 

```Swift
import FontSystemKit
import UIKit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // ...

    // Set (nearly) all labels to use the appropriate size/weight of American Typewriter
    UILabel.appearance().fontSystem = FontSystem(baseName: "AmericanTypewriter", boldSuffix: "-Bold")
    
    // ...
    
    return true
}
```

### Choosing Your Own Fonts for Each Style

If you use the no-argument constructor, the font system is initialized with the preferred system font for each text style. You can then individually set the font for only those text styles that you want to override:

```Swift
let fontSystem = FontSystem()
fontSystem.setFont(UIFont(name: "Avenir-Black", size: 20.0)!, forTextStyle: .headline)

UILabel.appearance().fontSystem = fontSystem
```

### Overriding the System Font Weight for a Particular Style

You can also choose a specific weight to use for a text style:

```Swift
let fontSystem = FontSystem(baseName: "Avenir",
                            regularSuffix: "-Book",
                            lightSuffix: "-Light",
                            mediumSuffix: "-Medium", 
                            heavySuffix: "-Heavy", 
                            blackSuffix: "-Black")!
                            
fontSystem.useWeight(.black, forTextStyle: .headline)

UILabel.appearance().fontSystem = fontSystem
```
