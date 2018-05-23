# HKAttributedTextView

HKAttributedTextView 是一个书写风格类似于 masonry 的富文本控件，它采用优雅的声明式方法定义富文本控件，和编程式的不同，它所需的代码量相当短，且非常直观易用。

## Usage

HKAttributedTextView 的用法非常简单明了:

1、引入控件
```Objective-C
#import "HKAttributeTextView.h"
```

2、声明控件为你的成员变量

```Objective-C
@property (nonatomic,strong) HKAttributeTextView *attrLabel;
```

3、初始化
```Objective-C
_attrLabel = [HKAttributeTextView make:^(HKAttributeTextMaker *make) {
    make.text(@"this is a ").font(14).color([UIColor blackColor]).attach();
    make.text(@"BlueLink").font(17).color([UIColor blueColor]).link(self,@selector(linkHandler:index:)).attach();
    make.text(@", and this is a ").font(14).color([UIColor blackColor]).attach();
    make.text(@"RedLink").font(17).color([UIColor redColor]).link(self,@selector(linkHandler:index:)).attach();
}];

```

3、对声明了 **`link`** 属性的部分定义回调
```Objective-C

- (void)linkHandler:(NSString *)text index:(NSUInteger)index {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:text message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

```

结果会是这样：

<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/1.png" width = "50%" />

点击带有 **`link`** 属性的部分，将产生回调：

<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/2.png" width = "50%" />

## Installation

```
pod 'HKAttributedTextView'
```
最新 pod 版本：`1.1`

最低 iOS 版本： `8.0`

## License

HKAttributedTextView is released under the MIT license. See [LICENSE](https://github.com/hon-key/HKAttributedTextView/raw/master/LICENSE) for details.
