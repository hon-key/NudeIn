//
//  ViewController.m
//  textExample
//
//  Created by 工作 on 2018/5/14.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "NudeIn.h"



@interface ViewController ()

@property (nonatomic,strong) NudeIn *textView;
@property (nonatomic,strong) NudeIn *textView2;
@property (nonatomic,strong) NudeIn *textView3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
        make.left.right.equalTo(self.view);
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

- (void)linkHandler:(NUDAction *)action {
    
    if ([action isKindOfClass:[NUDLinkAction class]]) {
        
        NUDLinkAction *linkAction = (NUDLinkAction *)action;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:linkAction.string message:nil preferredStyle:UIAlertControllerStyleAlert];
    
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

- (NudeIn *)textView {
    if (!_textView) {
        _textView = [NudeIn make:^(NUDTextMaker *make) {
            
            make.text(@"this is a").font(14).color([UIColor blackColor]).mark([UIColor redColor]).skew(0.3).attach();
            
//            make.text(@"BlueLink").fontName(@"GillSans",17).color([UIColor blueColor]).link(self,@selector(linkHandler:))._(NUDDashDotDot,[UIColor redColor]).attach();
//
//            make.text(@", and this is a ").font(14).color([UIColor blackColor]).kern(4).attach();
//
//            make.text(@"RedLink dd").font(17).color([UIColor redColor]).link(self,@selector(linkHandler:))._(NUD__,[UIColor redColor]).deprecated([UIColor purpleColor]).attach();
//
//            make.text(@"。").font(14).color([UIColor blackColor]).attach();
        }];
    }
    return _textView;
}

- (NudeIn *)textView2 {
    if (!_textView2) {
        _textView2 = [NudeIn make:^(NUDTextMaker *make) {
            
            make.text(@"RNG").color([UIColor greenColor]).attachWith(@"tpl1",nil);
            make.text(@"大战").font(17).color([UIColor blackColor]).attach();
            make.text(@"KZ").font(14).bold().color([UIColor blueColor]).attach();
        }];
    }
    return _textView2;
}

- (NudeIn *)textView3 {
    if (!_textView3) {
        _textView3 = [NudeIn make:^(NUDTextMaker *make) {
            
            make.allImage().size(120,120).ln(3).attach();
            make.imageTemplate(@"im1").size(100,100).attach();
            make.allText().font(20).color([UIColor redColor]).skew(0).kern(6).ln(2).attach();
            make.textTemplate(@"shadow").shadowOffset(-5,-3).shadowBlur(5).shadowColor([UIColor redColor]).attach();
            NSShadow *shadow = [NSShadow new];
            shadow.shadowOffset = CGSizeMake(5,5);
            shadow.shadowColor = [UIColor purpleColor];
            shadow.shadowBlurRadius = 7;
            make.textTemplate(@"shadowRes").shadowRes(shadow).attach();
            make.textTemplate(@"tp1").font(20).color([UIColor purpleColor]).ln(1).attach();
            make.textTemplate(@"tp2").font(10).color([UIColor redColor]).ln(1).attach();

            make.text(@"RNG").color([UIColor blueColor]).attach();
            make.text(@"\ue056大战").attach();
            make.image(@"replayIcon").ln(1).nud_attachWith(@"");
            make.text(@"KZ").solid(3,[UIColor redColor]).nud_attachWith(@"tp1",@"tp2");
            make.image(@"replayIcon").ln(4).nud_attachWith(@"im1",@"im2");

            make.text(@"hey,this is shadow").font(40).color([UIColor blueColor]).mark([UIColor grayColor]).ln(1).nud_attachWith(@"shadow");
            make.text(@"use shadowRes").font(40).color([UIColor blueColor]).ln(1).nud_attachWith(@"shadowRes");
            make.text(@"Text effect").font(40).color([UIColor redColor]).letterpress().ln(1).nud_attachWith(@"");
            make.text(@"Base").font(40).color([UIColor blackColor]).nud_attachWith(@"");
            make.text(@"L").font(40).color([UIColor blueColor]).vertical(-10).nud_attachWith(@"");
            make.text(@"ine").font(40).color([UIColor blackColor]).ln(1).nud_attachWith(@"");
            make.text(@"stretch").font(17).color([UIColor blueColor]).stretch(0.5).ln(1).nud_attachWith(@"");
            make.text(@"reverse").font(35).reverse().ln(1).nud_attachWith(@"");

            make.textTemplate(@"para").lineSpacing(0).attach();
            make.text(@"vertical layout,vertical layoutvertical layoutvertical layoutvertical layoutvertical layoutvertical layoutvertical layoutvertical layout").font(17).ln(1).nud_attachWith(@"para");
            make.text(@"line height.").font(17).lineHeight(0,50,100).ln(1).mark([UIColor grayColor]).nud_attachWith(@"");
            make.text(@"this is paragraph,this is paragraph.this is paragraph,this is paragraph.\n this is paragraph,this is paragraph.\n this is paragraph,this is paragraph.").font(17).paraSpacing(10,10).ln(1).nud_attachWith(@"");
            make.text(@"left").font(17).aligment(NUDAliLeft).ln(1).nud_attachWith(@"");
            make.text(@"center").font(17).aligment(NUDAliCenter).ln(1).nud_attachWith(@"");
            make.text(@"right").font(17).aligment(NUDAliRight).ln(1).nud_attachWith(@"");
            make.text(@"There is a \"significant\" link between higher temperatures and lower school achievement, say economic researchers.\nAn analysis of test scores of 10 million US secondary school students over 13 years shows hot weather has a negative impact on results.\nThe study says a practical response could be to use more air conditioning.\nStudents taking exams in a summer heatwave might have always complained that they were ").fl_headIndent(20).font(17).linebreak(NUDWord).ln(1).nud_attachWith(@"");
            make.text(@"Hello World").font(30).color([UIColor greenColor]).shadowOffset(-3,3).shadowBlur(4).shadowColor([[UIColor blackColor] colorWithAlphaComponent:0.33]).aligment(NUDAliCenter).ln(1).nud_attachWith(@"");
            make.text(@"M416").font(20).nud_attachWith(@"");
            make.text(@"[1]").font(10).vertical(10).link(self,@selector(linkHandler:)).nud_attachWith(@"");
 

        }];
        _textView3.backgroundColor = [UIColor greenColor];
        _textView3.scrollEnabled = YES;
        [_textView3 p];
    }
    return _textView3;
}


@end
