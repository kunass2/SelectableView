# BSSelectableView

## Installation

`BSSelectableView` is available through [CocoaPods](https://cocoapods.org/?q=bsselectab). To install
it, simply add the following line to your Podfile:

```ruby
pod "BSSelectableView"
```

If you used `use_framework` in your podfile just simply do:

```Swift
import BSSelectableView

```

for every file when you need to use it.

you may also use:

```Swift
@import BSSelectableView;

```

within **bridging header** file and avoid to import framework for every needed file.

##Info   


- entirely written in latest Swift syntax.

##Usage

Simply add `BSSingleSelectableView` or `BSMultiSelectableView` as a subclass of your `UIView` in Interface Builder.

#### Connect following `@IBOutlets`:

```Swift
@IBOutlet public var contentOptionsHeightConstraint: NSLayoutConstraint!
@IBOutlet public var contentOptionsView: UIView!
@IBOutlet public var textField: UITextField! //only BSSingleSelectableView
@IBOutlet public var tokenField: BSTokenView! //only BSMultiSelectableView
```

#### Connect following `@IBActions`:

```Swift
@IBAction public func switchButtonTapped(sender: UIButton) { ... }
```

#### Assing delegates for your selectable views in `viewDidLoad()`:

```Swift
selectableView.delegate = self
multiselectableView.delegate = self
```

#### Conform your `UIViewController` to `BSSelectableViewDelegate` declared as following:

```Swift
@objc public protocol BSSelectableViewDelegate {
    
    func selectableOptionsForSelectableViewWithIdentifier(identifier: String) -> [BSSelectableOption] //called only once along with switchButtonTapped()
    optional func singleSelectableView(view: BSSingleSelectableView, didSelectOption option: BSSelectableOption)
    optional func multiSelectableView(view: BSMultiSelectableView, didSelectOption option: BSSelectableOption)
    optional func multiSelectableView(view: BSMultiSelectableView, didRemoveOption option: BSSelectableOption)
    optional func multiSelectableView(view: BSMultiSelectableView, tokenViewForOption option: BSSelectableOption, atIndex index: Int) -> UIView
    optional func lineHeightForTokenInMultiSelectableView() -> CGFloat //default is 30
}
```

#### Additionally in Interface Builder you may set up for every `BSSelectableView` the following properties:

```Swift
@IBInspectable public var identifier: String = "" //to differentiate selectable views
@IBInspectable public var maxNumberOfRows: Int = 6 //while selecting rows
@IBInspectable public var cornerRadius: CGFloat = 3 //no words needed
```

#### You may also do some customizing:

```Swift
	BSSelectableView.tintColorForSelectedOption = UIColor.blueColor()
    static public var titleColorForSelectedOption = UIColor.greenColor()
    static public var titleColorForOption = UIColor.blackColor()
    static public var fontForOption = UIFont.systemFontOfSize(16)
    static public var heightForOption = 40
```

#### If you need you are able to call public instance methods:

```Swift
public func hideOptions() //collapse selectable options
public func updateView() //update view once you perform changes on the source
```

#### You have access to the following properties:

```Swift
public var options: [BSSelectableOption]? //current list of options able to select it
public var selectedOption: BSSelectableOption? //BSSingleSelectableView
public var selectedOptions = [BSSelectableOption]() //BSMultiSelectableView
```

#### `BSSelectableOption` is defined as follows:

```Swift
let option = BSSelectableOption(identifier: 0, title: "First")
```

## Author

Bartłomiej Semańczyk, bartekss2@icloud.com

## License

`BSSelectableView` is available under the MIT license. See the LICENSE file for more info.