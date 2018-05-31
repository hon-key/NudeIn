<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/logo.png" width = "100%" />

# NudeIn

NudeIn 是一个基于 UITextView ，书写风格类似于 masonry 的 iOS 端富文本控件，它采用优雅的声明式方法定义富文本控件，和编程式的不同，它所需的代码量相当短，且非常直观易用。

## Usage

NudeIn 的用法非常简单明了，这里给出一个非常简单的例子，相信你会被这样的用法惊艳到，一旦用起来就会爱不释手:

1、引入控件
```Objective-C
#import "NudeIn.h"
```

2、声明控件为你的成员变量

```Objective-C
@property (nonatomic,strong) NudeIn *attrLabel;
```

3、Do it yourself
```Objective-C
_attrLabel = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"this is a ").font(14).color([UIColor blackColor]).attach();
    make.text(@"BlueLink").font(17).color([UIColor blueColor]).link(self,@selector(linkHandler:)).attach();
    make.text(@", and this is a ").font(14).color([UIColor blackColor]).attach();
    make.text(@"RedLink").font(17).color([UIColor redColor]).link(self,@selector(linkHandler:)).attach();
}];

```

3、对声明了 **`link`** 属性的部分定义回调
```Objective-C

- (void)linkHandler:(NUDAction *)action {
    
    if ([action isKindOfClass:[NUDLinkAction class]]) {
        
        NUDLinkAction *linkAction = (NUDLinkAction *)action;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:linkAction.string message:nil preferredStyle:UIAlertControllerStyleAlert];
    
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

```

结果会是这样：

<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/1.png" width = "50%" />

点击带有 **`link`** 属性的部分，将产生回调：

<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/2.png" width = "50%" />


## Documents

* ### [Text](#usage)

    - [**font**](#usage) **`通过大小声明字体，统一使用系统字体`**

    - [**fontName**](#usage) **`通过字体名以及大小声明字体`**

    - [**fontRes**](#usage) **`通过 UIFont 声明字体`**

    - [**fontStyle**](#usage) **`声明字体的风格，如 Bold、Light 等`**

    - [**bold**](#usage) **`声明字体为 Bold 风格，如果有的话`**

    - [**color**](#usage) **`声明文字的前景色`**

    - [**mark**](#usage) **`声明文字的底色`**

    - [**hollow**](#usage) **`声明文字为镂空`**

    - [**link**](#usage) **`声明文字为链接文字`**

    - [**_**](#usage) **`声明文字带下划线`**

    - [**deprecated**](#usage) **`声明文字带删除线`**

    - [**skew**](#usage) **`声明文字为斜体`**

    - [**kern**](#usage) **`声明文字的紧凑程度`**

    - [**linefeed**](#usage) **`声明文字换行`**

## Installation

```
pod 'NudeIn' '~> 1.2.1-beta'
```
最新 pod 版本：`1.2.1-beta`

目前该版本属于不稳定版本

最低 iOS 版本： `8.0`

## License

HKAttributedTextView is released under the MIT license. See [LICENSE](https://github.com/hon-key/HKAttributedTextView/raw/master/LICENSE) for details.
