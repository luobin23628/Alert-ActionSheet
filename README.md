# Alert-ActionSheet
自定义AlertView和ActionSheet
==========

This library provides an alternative to the native iOS alertView & actionSheet, support customize the look and feel of the alertView.

<img width="320" height="568" src="https://raw.githubusercontent.com/luobin23628/Alert-ActionSheet/gh-pages/images/IMG_0100.PNG" alt="alt text" title="Title" /> _ 
<img style="margin-left:20px" width="320" height="568" src="https://raw.githubusercontent.com/luobin23628/Alert-ActionSheet/gh-pages/images/IMG_0104.PNG" alt="alt text" title="Title" />

<img width="568" height="320" src="https://raw.githubusercontent.com/luobin23628/Alert-ActionSheet/gh-pages/images/IMG_0098.PNG" alt="alt text" title="Title" />


##Installation

### CocoaPods
Add pod 'TKAlert&TKActionSheet' to your Podfile or pod 'TKAlert&TKActionSheet', :head if you're feeling adventurous.

### Manually
* Drag the `TKAlert&TKActionSheet` folder into your project.

##Features
* Compatible with ios 5+
* Works like system alert.
* Runs on both iPhone and iPad.
* Customize the look of alert.
* Automatic orientation.
* MIT License (you can use it for commercial apps, edit and redistribute).

## Usage
Let's start with a simple example
    
```objective-c
    TKAlertViewController *alert = [TKAlertViewController alertWithTitle:@"test" message:@"自定义AlertView和ActionSheet. cocoapads 使用 pod 'TKAlert&TKActionSheet', '~>1.0.1'"];
    [alert addButtonWithTitle:@"ok" handler:^{
        
    }];
    [alert addButtonWithTitle:@"cancel" handler:nil];
    alert.dismissWhenTapWindow = YES;
    [alert showWithAnimationType:TKAlertViewAnimationPathStyle];
```
## Maintainers

- [LuoBin](https://github.com/luobin23628) ([Email:luobin23628@gmail.com](mailto:luobin23628@gmail.com?subject=TKKeyboard))

## License

Alert-ActionSheet is available under MIT license. See the LICENSE file for more info.
