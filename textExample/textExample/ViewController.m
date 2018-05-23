//
//  ViewController.m
//  textExample
//
//  Created by 工作 on 2018/5/14.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "ViewController.h"
#import "HKAttributeTextView.h"
#import <Masonry.h>


@interface ViewController ()

@property (nonatomic,strong) HKAttributeTextView *textView;
@property (nonatomic,strong) HKAttributeTextView *textView2;

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

}

- (void)linkHandler:(NSString *)text index:(NSUInteger)index {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:text message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (HKAttributeTextView *)textView {
    if (!_textView) {
        _textView = [HKAttributeTextView make:^(HKAttributeTextMaker *make) {
            
            make.text(@"this is a ").font(14).color([UIColor blackColor]).mark([UIColor redColor]).skew(0.3).attach();
            
            make.text(@"BlueLink").fontName(@"GillSans",17).color([UIColor blueColor]).link(self,@selector(linkHandler:index:))._([UIColor redColor]).attach();
            
            make.text(@", and this is a ").font(14).color([UIColor blackColor]).kern(4).attach();
            
            make.text(@"RedLink").font(17).color([UIColor redColor]).link(self,@selector(linkHandler:index:))._([UIColor redColor]).deprecated([UIColor purpleColor]).attach();
            
            make.text(@"。").font(14).color([UIColor blackColor]).attach();
        }];
    }
    return _textView;
}

- (HKAttributeTextView *)textView2 {
    if (!_textView2) {
        _textView2 = [HKAttributeTextView make:^(HKAttributeTextMaker *make) {
            
            make.text(@"RNG").font(30).hollow(1,[UIColor redColor]).attach();
            make.text(@"大战").font(17).color([UIColor blackColor]).attach();
            make.text(@"KZ").font(14).bold().color([UIColor blueColor]).attach();
        }];
    }
    return _textView2;
}


@end
