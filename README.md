<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/logo.png" width = "100%" />

# NudeIn

[![Build Status](https://travis-ci.org/hon-key/NudeIn.svg?branch=master)](https://travis-ci.org/hon-key/NudeIn)
[![Cocoapods](https://img.shields.io/badge/pod-1.2.4-orange.svg)](https://img.shields.io/badge/pod-1.2.4-orange.svg)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![Language](https://img.shields.io/badge/language-Objective--C-blue.svg)](https://img.shields.io/badge/language-Objective--C-blue.svg)

NudeIn 是一个基于 UITextView ，书写风格类似于 masonry 的 iOS 端富文本控件，它采用优雅的声明式(链式)方法定义富文本控件，和编程式的不同，它所需的代码量相当短，且非常直观易用。

与此同时，NudeIn 不止于此，它会是一款非常灵性的富文本控件，它会将减少代码冗余提高到极致。比如考虑到一点，富文本里可能会有多于 2 个的风格一致的富文本，也有可能仅仅只是风格部分一致的富文本，比如字体大小不一样，比如颜色不一样。这样的代码如果按照常规去写，可能会出现大量相同的代码段。为了解决这个问题，NudeIn 引入了 **`模板`** ，你可以轻松声明一个模板，应用到任何需要它的组件上，而每个组件甚至可以声明属于自己的属性来覆盖模板上的属性，以达到部分一致的效果。这就是 NudeIn 非常灵活的地方。

相比其他第三方富文本库，NudeIn 将是最符合人类思维方式的，使用它将不会花费你太多的学习成本。如果你有 masonry 经验，你将几乎没有学习成本，如果你没有，也无需担心，它看起来就像是为你的思维方式精心打造的一般，只需稍微看看例子，就可以完全学会使用方法。

## Usage

NudeIn 的用法非常简单明了，这里给出一个非常简单的例子，相信你会被这样的用法惊艳到，一旦用起来就会爱不释手:

1、引入控件
```Objective-C
#import "NudeIn.h"
```

2、声明控件为你的成员变量

```objc
@property (nonatomic,strong) NudeIn *attrLabel;
```

3、Do it yourself
```objc
_attrLabel = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"this is a ").font(14).color([UIColor blackColor]).attach();
    make.text(@"BlueLink").font(17).color([UIColor blueColor]).link(self,@selector(linkHandler:)).attach();
    make.text(@", and this is a ").font(14).color([UIColor blackColor]).attach();
    make.text(@"RedLink").font(17).color([UIColor redColor]).link(self,@selector(linkHandler:)).attach();
}];

```

3、对声明了 **`link`** 属性的部分定义回调
```objc

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

## Installation

```
pod 'NudeIn'
```
最新 pod 版本：1.2.4

1、makeTemplate 功能，现在可以声明全局template了。

2、shadow 属性优化

3、新增 tap 属性，现在 text 可以声明 tap，引入回调，此属性可代替 link 属性

4、修复了一部分错误和 bug

5、image 组件添加 aligment 功能，可以在一行里为 image 声明 aligment 类型

最低 iOS 版本： `8.0`

## Indexes

* ### [Text](#usage)

    - [**font**](#font) **`通过大小声明字体，统一使用系统字体`**

    - [**fontName**](#fontname) **`通过字体名以及大小声明字体`**

    - [**fontRes**](#fontres) **`通过 UIFont 声明字体`**

    - [**fontStyle**](#fontstyle) **`声明字体的风格，如 Bold、Light 等`**

    - [**bold**](#bold) **`声明字体为 Bold 风格，如果有的话`**

    - [**color**](#color) **`声明文字的前景色`**

    - [**mark**](#mark) **`声明文字的底色`**

    - [**hollow**](#hollow) **`声明文字为镂空`**
    
    - [**solid**](#solid) **`声明文字为实心`**

    - [**link**](#link) **`声明文字为链接文字`**

    - [**_**](#_) **`声明文字带下划线`**

    - [**deprecated**](#deprecated) **`声明文字带删除线`**

    - [**skew**](#skew) **`声明文字为斜体`**

    - [**kern**](#kern) **`声明文字的紧凑程度`**

    - [**ln**](#ln) **`声明文字换行`**
    
    - [**ligature**](#ligature) **`声明文字为连体字`**
    
    - [**letterpress**](#letterpress) **`声明文字为印刷风格（凸起效果），该属性占用内存较高，谨慎使用`**
    
    - [**vertical**](#vertical) **`声明文字的垂直偏移`**
    
    - [**stretch**](#stretch) **`声明文字的水平拉伸程度（产生变形）`**
    
    - [**reverse**](#reverse) **`声明文字逆序书写`**
    
    - [**shadow**](#shadow) **`声明文字带默认阴影`**
    
    - [**shadowDirection**](#shadowdirection) **`声明文字带阴影，并且设定阴影为八个基本方向`**
    
    - [**shadowOffset**](#shadowoffset) **`声明文字带阴影，并且完全自定义阴影的方向`**
    
    - [**shadowBlur**](#shadowblur) **`声明文字带阴影，并自定义阴影的模糊程度`**
    
    - [**shadowColor**](#shadowcolor) **`声明文字带阴影，并自定义阴影颜色`**
    
    - [**shadowRes**](#shadowres) **`通过 NSShadow 声明并自定义阴影`**
    
    - [**lineSpacing**](#linespacing) **`声明文字的行距`**
    
    - [**lineHeight**](#lineheight) **`声明文字的行高，（最小行高，最大行高，行高倍数）`**
    
    - [**paraSpacing**](#paraspacing) **`声明文字每个自然段对其他自然段拉开的点距，（与前自然段拉开的点距，与后自然段拉开的点距）`**
    
    - [**aligment**](#aligment) **`声明文字的对齐方式，参数为 NUDAlignment`**
    
    - [**indent**](#indent) **`声明文字的缩进，（前缩进，后缩进）`**
    
    - [**fl_headIndent**](#fl_headindent) **`声明文字的首行前缩进，该属性会在首行覆盖 indent 的前缩进属性`**
    
    - [**linebreak**](#linebreak) **`声明文字的断行方式，参数为 NUDLineBreakMode`**
    
    - [**highlight**](#highlight) **`声明文字的触摸高亮，参数为一个模板的 id `** 
    
    - [**tap**](#tap) **`声明文字的触摸回调，参数为回调的 target 以及回调方法 `**  

* ### [Image](#usage)

    - [**origin**](#usage) **`声明图像的偏移，锚点为左下角`**
    
    - [**size**](#usage) **`声明图像的大小`**
    
    - [**ln**](#usage) **`声明图像换行`**
    
    - [**aligment**](#usage) **`声明图像对齐属性，参数为 NUDAligment`**

* ### [Template](#usage)

    - [**textTemplate**](#usage) **`声明一个 text 模板，以参数 identifier 来标识这个模板以重复使用，其使用方法和 text 一样`**
    
    - [**imageTemplate**](#usage) **`声明一个 image 模板，以参数 identifier 来标识这个模板以重复使用，其使用方法和 image 一样`**
    
    - [**allText**](#usage) **`声明所有使用 .attach() 的 text 都会被附加的属性，使用 .attachWith(@"") 不受影响`**
    
    - [**allImage**](#usage) **`声明所有使用 .attach() 的 image 都会被附加的属性，使用 .attachWith(@"") 不受影响`**
    
* ### [makeTemplate](#usage)

    - [**textTemplate**](#usage) **`全局声明一个 text 模板，以参数 identifier 来标识这个模板以重复使用，其使用方法和 text 一样`**
    
    - [**imageTemplate**](#usage) **`全局声明一个 image 模板，以参数 identifier 来标识这个模板以重复使用，其使用方法和 image 一样`**
    
    - [**allText**](#usage) **`全局声明所有使用 .attach() 的 text 都会被附加的属性，使用 .attachWith(@"") 不受影响`**
    
    - [**allImage**](#usage) **`全局声明所有使用 .attach() 的 image 都会被附加的属性，使用 .attachWith(@"") 不受影响`**

## Documents

### **font**

**font** 默认使用系统字体，如果只使用系统字体，它会让你的代码更简洁一些

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").font(32).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/font.png" />

### **fontName**

**fontName** 使用字体名称来设定字体，字体的名称可以是默认的family名称，也可以是特定粗细的字体名称

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").fontName(@"AmericanTypewriter",32).ln(1).attach();
    make.text(@"Github.com").fontName(@"AmericanTypewriter-Bold",32).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/fontName.png" />

### **fontRes**

**fontRes** 使用自定义的UIFont来设定字体，这里可以尽你所好

```objc
UIFont *font = [UIFont fontWithName:@"AmericanTypewriter" size:32];
UIFont *fontBold = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:32];
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").fontRes(font).ln(1).attach();
    make.text(@"Github.com").fontRes(fontBold).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/fontRes.png" />

### **fontStyle**

**fontStyle** 可以更加可读地去设定某个字体的风格，不过有一点要注意的是，这些得和字体本身的名字适配，如NUDBold风格，这需要相应字体拥有-Bold后缀,否则该方法将无效。

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").fontName(@"AmericanTypewriter",32).fontStyle(NUDBold).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/fontStyle.png" />

### **bold**

**bold** 出于bold比较常用来考虑，将 bold 作为属性出现也许会更加易读一些，其使用效果等同于 fontStyle

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").fontName(@"AmericanTypewriter",32).bold().attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/bold.png" />

### **color**

**color** 用于设定文字颜色，传入 UIColor 即可。

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().fontName(@"AmericanTypewriter",32).bold().attach();
    make.text(@"G").color([UIColor orangeColor]).attach();
    make.text(@"i").color([UIColor redColor]).attach();
    make.text(@"t").color([UIColor blueColor]).attach();
    make.text(@"h").color([UIColor magentaColor]).attach();
    make.text(@"u").color([UIColor brownColor]).attach();
    make.text(@"b").color([UIColor greenColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/color.png" />


### **mark**

**mark** 用于设定文字的底色，就像在书本里为某一行文字涂抹马克笔一样，这样看起来比较形象

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().fontName(@"AmericanTypewriter",32).color([UIColor whiteColor]).bold().attach();
    make.text(@"G").mark([UIColor orangeColor]).attach();
    make.text(@"i").mark([UIColor redColor]).attach();
    make.text(@"t").mark([UIColor blueColor]).attach();
    make.text(@"h").mark([UIColor magentaColor]).attach();
    make.text(@"u").mark([UIColor brownColor]).attach();
    make.text(@"b").mark([UIColor greenColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/mark.png" />

### **hollow**

**hollow** 可以让文字成为镂空状态，类似于艺术字那样,第一个参数可以边线的粗细，而第二个参数则可以设定颜色

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().fontName(@"AmericanTypewriter",32).bold().attach();
    make.text(@"G").hollow(4,[UIColor orangeColor]).attach();
    make.text(@"i").hollow(4,[UIColor redColor]).attach();
    make.text(@"t").hollow(4,[UIColor blueColor]).attach();
    make.text(@"h").hollow(4,[UIColor magentaColor]).attach();
    make.text(@"u").hollow(4,[UIColor brownColor]).attach();
    make.text(@"b").hollow(4,[UIColor greenColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/hollow.png" />


### **solid**

**solid** 表示其为实心，这样的话，我们可以自定义夹心的颜色，让字体看起来更加艺术

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().fontName(@"AmericanTypewriter",64).bold().color([UIColor cyanColor]).attach();
    make.text(@"G").solid(4,[UIColor orangeColor]).attach();
    make.text(@"i").solid(4,[UIColor redColor]).attach();
    make.text(@"t").solid(4,[UIColor blueColor]).attach();
    make.text(@"h").solid(4,[UIColor magentaColor]).attach();
    make.text(@"u").solid(4,[UIColor brownColor]).attach();
    make.text(@"b").solid(4,[UIColor greenColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/solid.png" />


### **link**

**link** 可以让文字成为一条链接，点击该链接将回调给予的方法。而在点击链接时，链接的背景会被置灰

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").font(64).link(self,@selector(linkHandler:)).color([UIColor blueColor])._(NUD_,[UIColor blueColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/link.png" />

### **_**

**_** 顾名思义，即下划线，使用它可以为你的文字加入下划线

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().fontName(@"AmericanTypewriter",32).bold().ln(1).color([UIColor cyanColor]).attach();
    make.text(@"Github")._(NUD_,[UIColor blueColor]).attach();
    make.text(@"Github")._(NUD__,[UIColor blackColor]).attach();
    make.text(@"Github")._(NUDThick_,[UIColor blueColor]).attach();
    make.text(@"Github")._(NUDDot,[UIColor blueColor]).attach();
    make.text(@"Github")._(NUDDotDot,[UIColor blueColor]).attach();
    make.text(@"Github")._(NUDDash,[UIColor blueColor]).attach();
    make.text(@"Github")._(NUDDashDot,[UIColor blueColor]).attach();
    make.text(@"Github")._(NUDDashDotDot,[UIColor blueColor]).attach();
    make.text(@"Github com")._(NUDDashDotDot|NUDByWord,[UIColor blueColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/_.png" />


### **deprecated**

**deprecated** 加入删除线，表示该文字已经被删除了或者是被废弃了，相对来说可读性高一些

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").font(64).deprecated([UIColor blackColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/deprecated.png" />


### **skew**

**skew** 给文字加斜度,斜度根据传入的 CGFloat 值的大小决定其斜度

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().fontName(@"AmericanTypewriter",32).bold().ln(1).aligment(NUDAliCenter).attach();
    make.text(@"Github.com").skew(0.0).attach();
    make.text(@"Github.com").skew(0.2).attach();
    make.text(@"Github.com").skew(0.4).attach();
    make.text(@"Github.com").skew(0.8).attach();
    make.text(@"Github.com").skew(1).attach();
    make.text(@"Github.com").skew(1.2).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/skew.png" />

### **kern**

**kern** 设定文字的紧凑程度,根据传入的 CGFloat 值的大小决定其紧凑度

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().fontName(@"AmericanTypewriter",32).bold().ln(1).aligment(NUDAliCenter).attach();
    make.text(@"Github.com").kern(0.0).attach();
    make.text(@"Github.com").kern(0.2).attach();
    make.text(@"Github.com").kern(0.4).attach();
    make.text(@"Github.com").kern(0.8).attach();
    make.text(@"Github.com").kern(1).attach();
    make.text(@"Github.com").kern(1.2).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/kern.png" />

### **ln**

**ln** 设定该组件换行，使用该属性可以无需手动在text里添加\n，并且传入大于1的整数还可以多次换行，特别要注意的是，换行符的属性也和该组件的其他字符串等同

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").font(32).ln(2).attach();
    make.text(@"Github.com").font(16).ln(2).attach();
    make.text(@"Github.com").font(32).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/ln.png" />

### **ligature**

**ligature** 声明文字为连体，使用之后，字体将会带有连体书写的效果，特别要注意的是，该属性只对部分支持连体的字母组以及字体有效

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"This is a attributed string").fontName(@"zapfino",23).ligature(NO).ln(1).attach();
    make.text(@"This is a attributed string").fontName(@"zapfino",23).ligature(YES).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/ligature.png" />

### **letterpress**

**letterpress** 声明文字带有印刷效果，

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github.com").font(64).letterpress().ln(1).attach();
    make.text(@"Github.com").font(64).ln(1).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/letterpress.png" />

### **vertical**

**vertical** 会让文字在垂直方向有一个偏移，传入一个CGFloat，如果大于0，则往上偏移，如果小于0，则往下偏移

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github").font(64).attach();
    make.text(@"[1]").font(15).color([UIColor blueColor]).vertical(35).ln(1).attach();
    make.text(@"Github").font(64).attach();
    make.text(@".com").font(32).color([UIColor orangeColor]).vertical(-20).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/vertical.png" />

### **stretch**

**stretch** 让文字在水平上有拉伸，其拉伸程度根据传入的CGFloat值而有所不同，换句话说，值越小越扁，越大越长

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github").font(64).ln(1).attach();
    make.text(@"Github").font(64).stretch(0.5).ln(1).attach();
    make.text(@"Github").font(64).stretch(-0.5).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/stretch.png" />


### **reverse**

**reverse** 让文字逆序书写

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github").font(64).ln(1).attach();
    make.text(@"Github").font(64).reverse().attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/reverse.png" />

### **shadow**

**shadow** 让文字带有默认的阴影效果，该效果让文字看起来会微小的凸起

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.text(@"Github").font(64).color([UIColor whiteColor]).shadow().attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/shadow.png" />

### **shadowDirection**

**shadowDirection** 让文字带有默认的阴影效果，并且可以定义阴影的四个最基本的方向：上下左右，至于第二个参数，则用于定义阴影的突出程度，需要注意的是，如果你用autolayout布局控件，它并不会因为阴影而自动扩大自己的frame，这时候你只能手动进行调整。

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(64).color([UIColor orangeColor]).aligment(NUDAliCenter).ln(1).attach();
    make.text(@"Github").shadowDirection(NUDLeft,10).attach();
    make.text(@"Github").shadowDirection(NUDRight,10).attach();
    make.text(@"Github").shadowDirection(NUDBottom,10).attach();
    make.text(@"Github").shadowDirection(NUDTop,10).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/shadowDirection.png" />

### **shadowOffset**

**shadowOffset** 让文字带有默认的阴影效果，并且可以完全自定义阴影的延伸方向

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(64).color([UIColor orangeColor]).aligment(NUDAliCenter).ln(1).attach();
    make.text(@"Github").shadowOffset(-5,-5).attach();
    make.text(@"Github").shadowOffset(5,5).attach();
    make.text(@"Github").shadowOffset(-5,5).attach();
    make.text(@"Github").shadowOffset(5,-5).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/shadowOffset.png" />

### **shadowBlur**

**shadowBlur** 让文字带有默认的阴影效果，并且可以完全自定义阴影的模糊程度，该值越高，则阴影越模糊，有种文字距离阴影越远的感觉

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(64).color([UIColor orangeColor]).shadowOffset(20,0).aligment(NUDAliCenter).ln(1).attach();
    make.text(@"Github").shadowBlur(0).attach();
    make.text(@"Github").shadowBlur(2).attach();
    make.text(@"Github").shadowBlur(4).attach();
    make.text(@"Github").shadowBlur(8).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/shadowBlur.png" />

### **shadowColor**

**shadowColor** 让文字带有默认的阴影效果，并且可以完全自定义阴影的颜色

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().shadowDirection(NUDRight,15).font(64).shadowBlur(3).color([UIColor orangeColor]).ln(1).attach();
    make.text(@"Github").shadowColor([UIColor redColor]).attach();
    make.text(@"Github").shadowColor([UIColor blueColor]).attach();
    make.text(@"Github").shadowColor([UIColor greenColor]).attach();
    make.text(@"Github").shadowColor([UIColor orangeColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/shadowColor.png" />

### **shadowRes**

**shadowRes** 让文字带有自定义的阴影效果，你可以传入 NSShadow，自定义阴影。

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(8, 0);
    shadow.shadowColor = [UIColor redColor];
    shadow.shadowBlurRadius = 3;
    make.text(@"Github").shadowRes(shadow).font(64).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/shadowRes.png" />

### **lineSpacing**

**lineSpacing** 让文字可以声明文字换行时产生的行距

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(32).color([UIColor orangeColor]).ln(1).attach();
    make.text(@"Github").lineSpacing(0).attach();
    make.text(@"Github").lineSpacing(8).attach();
    make.text(@"Github").lineSpacing(16).attach();
    make.text(@"Github").lineSpacing(32).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/lineSpacing.png" />

### **lineHeight**

**lineHeight** 声明文字的行高，它会往上延伸,需要注意这里有三个参数：

**`minimumLineHeight`** 为第一个参数，它定义一行的小高度，换句话说，只要该值不为 0，则行高最少为 **`minimumLineHeight`**

**`maximumLineHeight`** 为第二个参数，它定义一行的大高度，换句话说，只要该值不为 0，则行高最大为 **`maximumLineHeight`**

**`lineHeightMultiple`** 为第三个参数，它定义一行行高的倍数，换句话说，如果该值不为 0，则会基于原始的行高乘以 **`lineHeightMultiple`**。

一行的高并不只决定于 **`lineHeightMultiple`** ，如果你限制了 **`minimumLineHeight`** 和 **`maximumLineHeight`** ，就算设定过大的 **`lineHeightMultiple`** ，也不会超出你所限制的范围。

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(32).color([UIColor orangeColor]).ln(1).attach();
    make.text(@"Github").lineHeight(0,0,4).mark([UIColor redColor]).attach();
    make.text(@"Github").lineHeight(0,100,4).mark([UIColor blueColor]).attach();
    make.text(@"Github").lineHeight(100,0,0).mark([UIColor greenColor]).attach();
    make.text(@"Github").lineHeight(100,0,1).mark([UIColor blueColor]).attach();
    make.text(@"Github").lineHeight(100,0,4).mark([UIColor redColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/lineHeight.png" />

### **paraSpacing**

**paraSpacing** 让文字换行时产生额外的间距，分为两个参数：第一个参数为上间距，第二个参数为下间距

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(32).color([UIColor orangeColor]).ln(1).attach();
    make.text(@"Github").paraSpacing(20,20).mark([UIColor redColor]).attach();
    make.text(@"Github").paraSpacing(20,30).mark([UIColor blueColor]).attach();
    make.text(@"Github").paraSpacing(30,40).mark([UIColor greenColor]).attach();
    make.text(@"Github").paraSpacing(40,50).mark([UIColor blueColor]).attach();
    make.text(@"Github").paraSpacing(50,60).mark([UIColor redColor]).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/paraSpacing.png" />

### **aligment**

**aligment** 定义文字的对齐情况

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(32).color([UIColor orangeColor]).mark([UIColor greenColor]).ln(1).attach();
    make.text(@"Github").aligment(NUDAliLeft).attach();
    make.text(@"Github").aligment(NUDAliCenter).attach();
    make.text(@"Github").aligment(NUDAliRight).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/aligment.png" />

### **indent**

**indent** 定义文字的缩进，第一个参数为前缩进，第二个参数为后缩进

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(17).color([UIColor orangeColor]).mark([UIColor blueColor]).ln(2).indent(30,20).attach();
    make.text(@"GitHub Inc. is a web-based hosting service for version control using Git.").attach();
    make.text(@"It is mostly used for computer code.").indent(60,0).attach();
    make.text(@"It offers all of the distributed version control and source code management (SCM) functionality of Git as well as adding its own features.").indent(0,60).attach();
    make.text(@"It provides access control and several collaboration features such as bug tracking, feature requests, task management, and wikis for every project.").attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/indent.png" />

### **fl_headIndent**

**fl_headIndent** 定义文字的首行缩进，如果你定义过 indent 属性，它会在首行覆盖 indent 属性的前缩进属性

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(17).color([UIColor orangeColor]).mark([UIColor blueColor]).ln(1).fl_headIndent(40).attach();
    make.text(@"GitHub Inc. is a web-based hosting service for version control using Git. ").attach();
    make.text(@"It is mostly used for computer code. ").attach();
    make.text(@"It offers all of the distributed version control and source code management (SCM) functionality of Git as well as adding its own features.").attach();
    make.text(@"It provides access control and several collaboration features such as bug tracking, feature requests, task management, and wikis for every project.").attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/fl_headIndent.png" />

### **linebreak**

**linebreak** 定义文字的换行方式

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.allText().font(17).color([UIColor orangeColor]).mark([UIColor blueColor]).ln(2).attach();
    make.text(@"It is mostly used for computer code.").linebreak(NUDWord).attach();
    make.text(@"It is mostly used for computer code.").linebreak(NUDChar).attach();
    make.text(@"It is mostly used for computer code.").linebreak(NUDClip).attach();
    make.text(@"It is mostly used for computer code.").linebreak(NUDTr_head).attach();
    make.text(@"It is mostly used for computer code.").linebreak(NUDTr_tail).attach();
    make.text(@"It is mostly used for computer code.").linebreak(NUDTr_middle).attach();
}];
```
<img src="https://github.com/hon-key/HKAttributedTextView/raw/master/Screenshots/linebreak.png" />

### **highlight**

**highlight** 定义文字高亮，通过传入模板，可以定义高亮时文字的属性

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.textTemplate(@"Highlight").color([UIColor greenColor]).font(64).attach();
    make.text(@"Github").font(64).color([UIColor blackColor]).highlighted(@"Highlight").attach();
}];
```

### **tap**

**tap** 定义文字单击所产生的回调，该属性和 link 属性的效果是一致的，不过相比link属性，它的单击区域紧紧限制在文字之内，并且配合highlight方法，你可以做到完全自定义单击风格

```objc
NudeIn *nude = [NudeIn make:^(NUDTextMaker *make) {
    make.textTemplate(@"Highlight").color([UIColor greenColor]).font(64).attach();
    make.text(@"Github").font(64).color([UIColor blackColor]).highlighted(@"Highlight").tap(self,@selector(linkHandler:)).attach();
}];
```

## License

NudeIn is released under the MIT license. See [LICENSE](https://github.com/hon-key/HKAttributedTextView/raw/master/LICENSE) for details.
