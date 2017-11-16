                                                                    //
//  GradientCircleView.m
//  gradientDemo
//
//  Created by Gargit on 16/12/24359.
//  Copyright © 2016年 gargit. All rights reserved.
//

#import "ARCirclePieView.h"
#import "ARCirclePieModel.h"



@implementation ARCirclePieView

- (void)drawArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAgle:(CGFloat)endAgle lineWidth:(CGFloat)lineWidth colors:(NSArray<UIColor *>*)colors isClockwise:(BOOL) clockwise {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.layer.bounds;


    if (clockwise == NO) {
        //逆时针，角度取反
        startAngle = -startAngle;
        endAgle = -endAgle;
        
        //起始点从圆的上顶部开始
        CGFloat offsetAngle = -M_PI_2;
        startAngle += offsetAngle;
        endAgle += offsetAngle;
    }

    
    // 顺时针画一个圆弧
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAgle clockwise:0];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineCap = kCALineCapButt;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    
    // 渐变色的颜色
    NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [colorArr addObject:(id)color.CGColor];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = shapeLayer.bounds;
    gradientLayer.colors = colorArr;
    gradientLayer.startPoint = CGPointMake((radius + radius * cos(startAngle)) / (2 * radius), (radius + radius * sin(startAngle)) / (2 * radius));
    gradientLayer.endPoint = CGPointMake((radius + radius * cos(endAgle)) / (2 * radius), (radius + radius * sin(endAgle)) / (2 * radius));
    gradientLayer.mask = shapeLayer;
    [self.layer addSublayer:gradientLayer];
    
}

-(void)creatCircleWithArray:(NSArray*)allArray andCircleWidth:(CGFloat)CircleWidth andTriangleWidth:(CGFloat) triangleWidth {
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGFloat startAngle = 0;
    CGFloat radius = center.x-CircleWidth/2.0;
   
    ARCirclePieModel *mode = [allArray objectAtIndex:0];
    int sumValue = [self sum:allArray];
    CGFloat endAgle = [mode.value floatValue]/sumValue*M_PI*2;
    for (int i = 0; i<allArray.count; i++) {
        
        ARCirclePieModel *mode = [allArray objectAtIndex:i];
        //先画三角
        if([mode.value intValue]>0)
        {
            UIColor *middleColor = [self middleColor:mode.startColor  toColor:mode.endColor percent:0.5];
            [self getPointWithBeginAngle:startAngle
                             AndEndANgle:endAgle
                        andTextlabelText:mode.value
                              WithBounds:self.bounds
                              andRadious:radius
                            andLineWidth:CircleWidth
                        andTriangleWidth:triangleWidth
                        andTriangleColor:middleColor andClockwise:NO];
            
            //再画弧形
            [self drawArcWithCenter:center radius:radius startAngle:startAngle endAgle:endAgle lineWidth:CircleWidth colors:@[mode.startColor, mode.endColor] isClockwise:NO];
        }
        startAngle = endAgle;
        if (i+1<=allArray.count -1) {
            endAgle = [self findendAngle:allArray index:i+1]/sumValue*M_PI*2;
        }
    }
}



- (int)sum:(NSArray*)array
{
    
    int sumValue = 0;
    for (int i = 0;i<array.count;i++) {
        ARCirclePieModel *model = [array objectAtIndex:i];
        int value = [model.value intValue];
        sumValue +=value;
    }
    return sumValue;
}

- (CGFloat )findendAngle:(NSArray *)array index:(int)index
{
    CGFloat value = 0;
    for (int i = index; i>=0; i--) {
        ARCirclePieModel *m = [array objectAtIndex:i];
        value +=[m.value floatValue];
    }
    return value;
}



//计算点坐标  绘画3角形
-(void)getPointWithBeginAngle:(CGFloat)beginAngle  //开始角度  参数范围0-2M_PI
                      AndEndANgle:(CGFloat)endAngle     //结束角度  参数范围0-2M_PI
                 andTextlabelText:(NSString*)text  // label 数据
                       WithBounds:(CGRect)boundes       // 画布frame
                       andRadious:(CGFloat)radious      // 弧半径
                     andLineWidth:(CGFloat)lineWidth    // 弧线宽度
                 andTriangleWidth:(CGFloat) TriangleWidth   //绘画三角形的宽度
                 andTriangleColor:(UIColor*)triangleColor
                    andClockwise :(BOOL)clockWise{          //NO表示逆时针旋转  YES顺时针旋转
    

    if (clockWise == NO) {
        //逆时针，角度取反
        beginAngle = -beginAngle;
        endAngle = -endAngle;
        
        //起始点从圆的上顶部开始
        CGFloat offsetAngle = -M_PI_2;
        beginAngle += offsetAngle;
        endAngle += offsetAngle;
    }

    //判断是否放得下三角形
     if (TriangleWidth <= (radious*fabs(sin(endAngle-beginAngle)))) {  // 三角形
        
         CGFloat add_x = sqrt(pow(radious, 2) - pow(TriangleWidth/2.0, 2));
        //坐标转换 确保范围在0-2M_PI
        //计算三角形坐标
        CGPoint pointTop = CGPointZero;
        CGPoint pointBottom = CGPointZero;
        CGPoint pointHead = CGPointZero;
        
        
        pointTop.x = (boundes.origin.x+boundes.size.width)/2.0+add_x;
        pointTop.y = (boundes.origin.y+boundes.size.height)/2.0 - TriangleWidth/2.0;
        
        pointBottom.x = pointTop.x;
        pointBottom.y = pointTop.y + TriangleWidth;
        
        pointHead.x = pointTop.x - sqrt(3)/2*TriangleWidth;
        pointHead.y = pointTop.y + TriangleWidth/2.0;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        // 2. 设置相关属性
        path.lineWidth = 1.0f;               // 线条宽度
        [[UIColor redColor] set];            // 线条颜色
        path.lineCapStyle = kCGLineCapRound; // 线条拐角
        path.lineJoinStyle = kCGLineCapRound;// 终点处理
        // 3.通过moveToPoint:设置起点
        [path moveToPoint:pointHead];
        // 添加line为subPaths
        [path addLineToPoint:pointTop];
        [path addLineToPoint:pointBottom];
        [path closePath];
        // 开始绘画
        [path stroke];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;// 设置图层大小
        shapeLayer.path = path.CGPath;// 设置shapeLayer的cgPath
        shapeLayer.opacity = 1.0f;  //设置透明度0~1之间
        shapeLayer.lineCap = kCALineCapSquare;//制定线的边缘是圆形
        shapeLayer.lineWidth = 2.0f; // 设置线宽
        shapeLayer.strokeColor = triangleColor.CGColor;// 设置线条颜色
        [shapeLayer setFillColor:triangleColor.CGColor]; // 清楚填充颜色
        [self.layer addSublayer:shapeLayer];
        
        
        //用于旋转labyer 层
        //创建CATransform3D默认变换矩阵
        CATransform3D transA = CATransform3DIdentity;
        shapeLayer.transform = CATransform3DRotate(transA, (endAngle+beginAngle)/2, 0, 0, 1);
        
        UILabel* textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        [self addSubview:textLabel];
        textLabel.font = [UIFont systemFontOfSize:11];
        textLabel.text = text;
        
        CGPoint orgPoint;
         beginAngle+=2*M_PI;
         endAngle+=2*M_PI;
        if (beginAngle+endAngle <= 4*M_PI &&  beginAngle+endAngle>=3*M_PI) { // 右上角
            orgPoint.x = (boundes.origin.x+boundes.size.width)/2.0+(radious - TriangleWidth)* cos((beginAngle+endAngle)/2.0);
            orgPoint.y =   (boundes.origin.y+boundes.size.height)/2.0 + (radious - TriangleWidth)* sin((beginAngle+endAngle)/2.0);
            textLabel.frame = CGRectMake(orgPoint.x - 40/2 , orgPoint.y, 40, 20);
            
        }
        else if (beginAngle+endAngle<3*M_PI &&  beginAngle+endAngle>=2*M_PI) { //左上角
            orgPoint.x = (boundes.origin.x+boundes.size.width)/2.0+(radious - TriangleWidth)* cos((beginAngle+endAngle)/2.0);
            orgPoint.y =   (boundes.origin.y+boundes.size.height)/2.0 + (radious - TriangleWidth)* sin((beginAngle+endAngle)/2.0);
            textLabel.frame = CGRectMake(orgPoint.x , orgPoint.y, 40, 20);
            
        }
        else if (beginAngle+endAngle<2*M_PI &&  beginAngle+endAngle > M_PI) { // 左下角
            orgPoint.x = (boundes.origin.x+boundes.size.width)/2.0+(radious - TriangleWidth)* cos((beginAngle+endAngle)/2.0);
            orgPoint.y =   (boundes.origin.y+boundes.size.height)/2.0 + (radious - TriangleWidth)* sin((beginAngle+endAngle)/2.0);
            textLabel.frame = CGRectMake(orgPoint.x , orgPoint.y-20, 40, 20);
            
        }
        else{  // 右下角
            orgPoint.x = (boundes.origin.x+boundes.size.width)/2.0+(radious - TriangleWidth)* cos((beginAngle+endAngle)/2.0);
            orgPoint.y =   (boundes.origin.y+boundes.size.height)/2.0 + (radious - TriangleWidth)* sin((beginAngle+endAngle)/2.0);
            textLabel.frame = CGRectMake(orgPoint.x - 40/2 , orgPoint.y -20, 40, 20);
            
        }
        
    }
    else{  // 方形
        CGFloat add_x = radious - TriangleWidth*0.7;
        CGFloat heightRate = 0.15;
        CGPoint leftTop,rightTop,rightBottom,leftBottom;
        CGFloat squareHeight = (radious -  add_x)*heightRate;
        leftTop = CGPointMake((boundes.origin.x+boundes.size.width)/2.0+add_x, (boundes.origin.y+boundes.size.height)/2.0 - squareHeight/2.0);
        leftBottom = CGPointMake(leftTop.x, leftTop.y+squareHeight);
        rightTop = CGPointMake((boundes.origin.x+boundes.size.width)/2.0+radious, leftTop.y);
        rightBottom = CGPointMake(rightTop.x, rightTop.y+squareHeight);
        
        // 小方块宽度
        UIBezierPath *path = [UIBezierPath bezierPath];
        // 2. 设置相关属性
        path.lineWidth = 1.0f;               // 线条宽度
        [[UIColor redColor] set];            // 线条颜色
        path.lineCapStyle = kCGLineCapRound; // 线条拐角
        path.lineJoinStyle = kCGLineCapRound;// 终点处理
        // 3.通过moveToPoint:设置起点
        [path moveToPoint:leftTop];
        // 添加line为subPaths
        [path addLineToPoint:rightTop];
        [path addLineToPoint:rightBottom];
        [path addLineToPoint:leftBottom];
        [path closePath];
        // 开始绘画
        [path stroke];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;// 设置图层大小
        shapeLayer.path = path.CGPath;// 设置shapeLayer的cgPath
        shapeLayer.opacity = 1.0f;  //设置透明度0~1之间
        shapeLayer.lineCap = kCALineCapSquare;//制定线的边缘是圆形
        shapeLayer.lineWidth = 2.0f; // 设置线宽
        shapeLayer.strokeColor = triangleColor.CGColor;// 设置线条颜色
        [shapeLayer setFillColor:triangleColor.CGColor]; // 清楚填充颜色
        [self.layer addSublayer:shapeLayer];
        
        CATransform3D transA = CATransform3DIdentity;
        shapeLayer.transform = CATransform3DRotate(transA, (endAngle+beginAngle)/2, 0, 0, 1);
        
        UILabel* textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
        [self addSubview:textLabel];
        textLabel.font = [UIFont systemFontOfSize:11];
        textLabel.text = text;
        beginAngle+=2*M_PI;
        endAngle+=2*M_PI;
        CGPoint orgPoint;
        if (beginAngle+endAngle <= 4*M_PI &&  beginAngle+endAngle>=3*M_PI) { // 右上角
            orgPoint.x = (boundes.origin.x+boundes.size.width)/2.0+(radious - TriangleWidth)* cos((beginAngle+endAngle)/2.0);
            orgPoint.y =   (boundes.origin.y+boundes.size.height)/2.0 + (radious - TriangleWidth)* sin((beginAngle+endAngle)/2.0);
            textLabel.frame = CGRectMake(orgPoint.x - 40/2 , orgPoint.y, 40, 20);
            
        }
        else if (beginAngle+endAngle<3*M_PI &&  beginAngle+endAngle>=2*M_PI) { //左上角
            orgPoint.x = (boundes.origin.x+boundes.size.width)/2.0+(radious - TriangleWidth)* cos((beginAngle+endAngle)/2.0);
            orgPoint.y =   (boundes.origin.y+boundes.size.height)/2.0 + (radious - TriangleWidth)* sin((beginAngle+endAngle)/2.0);
            textLabel.frame = CGRectMake(orgPoint.x , orgPoint.y, 40, 20);
            
        }
        else if (beginAngle+endAngle<2*M_PI &&  beginAngle+endAngle > M_PI) { // 左下角
            orgPoint.x = (boundes.origin.x+boundes.size.width)/2.0+(radious - TriangleWidth)* cos((beginAngle+endAngle)/2.0);
            orgPoint.y =   (boundes.origin.y+boundes.size.height)/2.0 + (radious - TriangleWidth)* sin((beginAngle+endAngle)/2.0);
            textLabel.frame = CGRectMake(orgPoint.x , orgPoint.y-20, 40, 20);
            
        }
        else{  // 右下角
            orgPoint.x = (boundes.origin.x+boundes.size.width)/2.0+(radious - TriangleWidth)* cos((beginAngle+endAngle)/2.0);
            orgPoint.y =   (boundes.origin.y+boundes.size.height)/2.0 + (radious - TriangleWidth)* sin((beginAngle+endAngle)/2.0);
            textLabel.frame = CGRectMake(orgPoint.x - 40/2 , orgPoint.y -20, 40, 20);
            
        }
    }
    
}

-(UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

@end
