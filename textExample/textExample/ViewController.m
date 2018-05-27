//
//  ViewController.m
//  textExample
//
//  Created by 工作 on 2018/5/14.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "ViewController.h"
#import "HKAttributedTextView.h"
#import <Masonry.h>


@interface ViewController ()

@property (nonatomic,strong) HKAttributedTextView *textView;
@property (nonatomic,strong) HKAttributedTextView *textView2;
@property (nonatomic,strong) HKAttributedTextView *textView3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.textView2];
    [self.textView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.textView3];
    [self.textView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-200);
        make.width.height.mas_equalTo(300);
    }];


}

- (void)linkHandler:(NSString *)text index:(NSUInteger)index {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:text message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (HKAttributedTextView *)textView {
    if (!_textView) {
        _textView = [HKAttributedTextView make:^(HKAttributedTextMaker *make) {
            
            make.text(@"this is a ").font(14).color([UIColor blackColor]).mark([UIColor redColor]).skew(0.3).attach();
            
            make.text(@"BlueLink").fontName(@"GillSans",17).color([UIColor blueColor]).link(self,@selector(linkHandler:index:))._(HKDashDotDot,[UIColor redColor]).attach();
            
            make.text(@", and this is a ").font(14).color([UIColor blackColor]).kern(4).attach();
            
            make.text(@"RedLink dd").font(17).color([UIColor redColor]).link(self,@selector(linkHandler:index:))._(HK__,[UIColor redColor]).deprecated([UIColor purpleColor]).attach();
            
            make.text(@"。").font(14).color([UIColor blackColor]).attach();
        }];
    }
    return _textView;
}

- (HKAttributedTextView *)textView2 {
    if (!_textView2) {
        _textView2 = [HKAttributedTextView make:^(HKAttributedTextMaker *make) {
            
            make.text(@"RNG").color([UIColor greenColor]).attachWith(@"tpl1",nil);
            make.text(@"大战").font(17).color([UIColor blackColor]).attach();
            make.text(@"KZ").font(14).bold().color([UIColor blueColor]).attach();
        }];
    }
    return _textView2;
}

- (HKAttributedTextView *)textView3 {
    if (!_textView3) {
        _textView3 = [HKAttributedTextView make:^(HKAttributedTextMaker *make) {
            
            make.allImage().size(120,120).linefeed(3).attach();
            make.imageTemplate(@"im1").size(100,100).attach();
            make.allText().font(20).color([UIColor redColor]).skew(0).kern(6).linefeed(2).attach();
            make.text(@"RNG").color([UIColor blueColor]).attach();
            make.text(@"\ue056大战").attach();
            make.image(@"replayIcon").linefeed(1).hk_attachWith(@"im1",@"im2");
            
            make.textTemplate(@"tp1").color([UIColor purpleColor]).linefeed(1).attach();
            make.textTemplate(@"tp2").font(40).color([UIColor redColor]).linefeed(1).attach();
            
            make.text(@"KZ").hk_attachWith(@"tp1",@"tp2");
            make.image(@"replayIcon").hk_attachWith(@"im1",@"im2");
        }];
        _textView3.backgroundColor = [UIColor greenColor];
        _textView3.scrollEnabled = YES;
    }
    return _textView3;
}


@end
