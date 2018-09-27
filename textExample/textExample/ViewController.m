//
//  ViewController.m
//  textExample
//
//  Created by 工作 on 2018/5/14.
//  Copyright © 2018年 com.CAI. All rights reserved.
//

#import "ViewController.h"
#import "NudeIn.h"
#import "UIImage+NUDPainter.h"

@interface ViewController ()

@property (nonatomic,strong) NudeIn *textView;
@property (nonatomic,strong) NudeIn *textView2;
@property (nonatomic,strong) NudeIn *textView3;
@property (nonatomic,strong) NudeIn *textView4;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView];
    self.textView.frame = CGRectMake(20, 50, 50, 20);
//    [self.textView sizeToFit];

    [self.view addSubview:self.textView2];
    self.textView2.frame = CGRectMake(20, 100, 0, 0);
    [self.textView2 sizeToFit];

    [self.view addSubview:self.textView3];
    self.textView3.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 300);

    [self.view addSubview:self.textView4];
    self.textView4.frame = CGRectMake(20, 500, 200, 150);
    
//    UIImage *image = [UIImage nud_imageWithColor:[UIColor redColor] size:CGSizeMake(80, 80) radius:40 quality:1];
//    UIColor *color = [UIColor colorWithPatternImage:image];
//    UIView *v = [UIView new];
//    v.backgroundColor = color;
//    v.frame = CGRectMake(50, 50, 80, 80);
//    [self.view addSubview:v];
    
    
}

- (void)linkHandler:(NUDAction *)action {
    
    if ([action isKindOfClass:[NUDLinkAction class]]) {
        
        NUDLinkAction *linkAction = (NUDLinkAction *)action;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:linkAction.string message:nil preferredStyle:UIAlertControllerStyleAlert];
    
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if ([action isKindOfClass:[NUDTapAction class]]) {
        
        NUDTapAction *tapAction = (NUDTapAction *)action;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tapAction.string message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (NudeIn *)textView {
    if (!_textView) {
        _textView = [NudeIn make:^(NUDTextMaker *make) {
            
            UIImage *image = [UIImage nud_imageWithColor:[UIColor redColor] size:CGSizeMake(57, 19) radius:9.5 quality:10];
            UIColor *color = [UIColor colorWithPatternImage:image];

            make.text(@" this is a ").font(14).color([UIColor blackColor]).mark(color).skew(0.3).attach();

            make.text(@"BlueLink").fontName(@"GillSans",17).color([UIColor blueColor]).link(self,@selector(linkHandler:))._(NUDDashDotDot,[UIColor redColor]).attach();

            make.text(@", and this is a ").font(14).color([UIColor blackColor]).kern(4).attach();

            make.text(@"RedLink dd").font(17).color([UIColor redColor]).link(self,@selector(linkHandler:))._(NUD__,[UIColor redColor]).deprecated([UIColor purpleColor]).attach();

            make.text(@"。").font(14).color([UIColor blackColor]).attach();
            
        }];
        _textView.selectable = YES;
    }
    return _textView;
}

- (NudeIn *)textView2 {
    if (!_textView2) {
        _textView2 = [NudeIn make:^(NUDTextMaker *make) {
            make.textTemplate(@"markRed").font(17).bold().color([UIColor redColor]).attach();
            make.textTemplate(@"markYellow").font(14).bold().color([UIColor yellowColor]).attach();
            make.text(@"RNG").color([UIColor greenColor]).attachWith(@"markRed",@"share1",nil);
            make.text(@"大战").font(17).color([UIColor blackColor]).highlighted(@"markRed").attach();
            make.text(@"KZ").font(14).bold().color([UIColor blueColor]).highlighted(@"markYellow").attach();
            make.allText().font(50).attach();
            make.text(@"RNG").color([UIColor redColor]).attach();
            make.text(@"KZ").color([UIColor blueColor]).attach();
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView2 remake:^(NUDTextMaker *make) {
                make.allText().font(50).attach();
                make.text(@"BBB").color([UIColor redColor]).attach();
                make.text(@"DDD").color([UIColor blueColor]).attach();
            }];
        });
    }
    return _textView2;
}

- (NudeIn *)textView3 {
    if (!_textView3) {
        _textView3 = [NudeIn make:^(NUDTextMaker *make) {
            
            UIImage *image = [UIImage nud_imageWithColor:[UIColor redColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 70) radius:35 quality:NUDImageQualityHigh];
            UIColor *color = [UIColor colorWithPatternImage:image];
            
            make.allImage().size(120,120).ln(3).attach();
            make.imageTemplate(@"im1").size(100,100).attach();
            make.allText().font(20).color([UIColor redColor]).skew(0).kern(6).ln(3).attach();
            make.textTemplate(@"shadow").shadowOffset(-5,-3).shadowBlur(5).shadowColor([UIColor redColor]).attach();
            NSShadow *shadow = [NSShadow new];
            shadow.shadowOffset = CGSizeMake(5,5);
            shadow.shadowColor = [UIColor purpleColor];
            shadow.shadowBlurRadius = 7;
            make.textTemplate(@"shadowRes").shadowRes(shadow).attach();
            make.textTemplate(@"tp1").font(20).color([UIColor purpleColor]).ln(1).attach();
            make.textTemplate(@"tp2").font(10).color([UIColor redColor]).ln(1).attach();

            make.text(@"RNG").color([UIColor blueColor]).mark(color).attach();
            make.text(@"\ue056大战").attach();
            make.image(@"replayIcon").ln(10).nud_attachWith(@"");
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
            make.text(@"[1]").font(10).vertical(10).ln(1).nud_attachWith(@"");

        }];
        _textView3.backgroundColor = [UIColor greenColor];
        _textView3.scrollEnabled = YES;
        _textView3.delaysContentTouches = YES;
        [_textView3 p];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView3 update:^(NUDTextUpdate *update) {
                update.comp(2).asImage.size(150,150).apply();
//                update.comp(0).asText.font(16).apply();
            }];
        });

    }
    return _textView3;
}

- (NudeIn *)textView4 {
    if (!_textView4) {
        [NudeIn makeTemplate:^(NUDTemplateMaker *make) {
            make.imageTemplate(@"imageTpl1").ln(1).aligment(NUDAliCenter).size(100,100).attach();
            make.textTemplate(@"normal").fontName(@"AmericanTypewriter",25).bold().aligment(NUDAliCenter).attach();
            make.textTemplate(@"tap").tap(self,@selector(linkHandler:)).attach();
            make.textTemplate(@"highlight").fontName(@"AmericanTypewriter",30).bold().solid(5,[UIColor redColor]).color([UIColor orangeColor]).aligment(NUDAliCenter).attach();
            
        }];
        _textView4 = [NudeIn make:^(NUDTextMaker *make) {
             make.textTemplate(@"tap").tap(self,@selector(linkHandler:)).attach();
            make.image(@"githubIcon").nud_attachWith(@"imageTpl1");
            make.text(@"Github").highlighted(@"highlight").nud_attachWith(@"normal",@"tap");
        }];
        _textView4.selectable = NO;
    }
    return _textView4;
}



@end
