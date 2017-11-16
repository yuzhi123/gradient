//
//  ViewController.m
//  gradientDemo
//
//  Created by Gargit on 16/12/24359.
//  Copyright © 2016年 gargit. All rights reserved.
//

#import "ViewController.h"
#import "ARCirclePieView.h"
#import "ARCirclePieModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ARCirclePieView *view = [[ARCirclePieView alloc]init];
    view.frame = CGRectMake(100, 100, 150, 150);
    view.backgroundColor = [UIColor whiteColor];
    
    
    ARCirclePieModel *mode1 = [[ARCirclePieModel alloc]init];
    mode1.value = @"100";
    mode1.startColor = [UIColor redColor];
    mode1.endColor = [UIColor blueColor];
    
    ARCirclePieModel *mode2 = [[ARCirclePieModel alloc]init];
    mode2.value = @"150";
    mode2.startColor = [self colorWithHexString:@"0xf5de4e" alpha:1];
    mode2.endColor = [self colorWithHexString:@"0xf1b537" alpha:1];
    
    ARCirclePieModel *mode3 = [[ARCirclePieModel alloc]init];
    mode3.value = @"180";
    
    mode3.startColor = [self colorWithHexString:@"0xdb7762" alpha:1];
    mode3.endColor = [self colorWithHexString:@"0xc03e60" alpha:1];
    
    ARCirclePieModel *mode4 = [[ARCirclePieModel alloc]init];
    mode4.value = @"210";

    mode4.startColor = [self colorWithHexString:@"0x06d9b2" alpha:1];
    mode4.endColor = [self colorWithHexString:@"0x037fa2" alpha:1];
    
    NSMutableArray* allArray = [NSMutableArray arrayWithObjects:mode1,mode2, mode3,mode4,nil];
    [view creatCircleWithArray:allArray andCircleWidth:10 andTriangleWidth:15];
    
    [self.view addSubview:view];
}


#pragma mark 设置16进制颜色
- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


@end
