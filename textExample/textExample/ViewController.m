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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
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
            
            make.text(@"this is a ").font(14).color([UIColor blackColor]).attach();
            make.text(@"BlueLink").font(17).color([UIColor blueColor]).link(self,@selector(linkHandler:index:)).attach();
            make.text(@", and this is a ").font(14).color([UIColor blackColor]).attach();
            make.text(@"RedLink").font(17).color([UIColor redColor]).link(self,@selector(linkHandler:index:)).attach();
            
        }];
    }
    return _textView;
}


@end
