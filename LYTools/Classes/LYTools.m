#import "LYTools.h"
#import "CommonCrypto/CommonDigest.h"

@implementation LYTools

/**
 对象转字符串
 */
+(NSString *)idToJsonString:(id)object{
    
    if (object == nil) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:0];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
    
}

/**
 json字符串转对象
 */
+(id)jsonStringToIDs:(NSString *)jString{
    
    if (jString == nil) {
        return nil;
    }

    NSData *jsonData = [jString dataUsingEncoding:NSUTF8StringEncoding];
    id ids = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:0];
    
    return ids;
    
}

+(NSArray *)dictionaryToArray:(NSDictionary *)dictionary{
    
    NSMutableArray *array = [NSMutableArray new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [array addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    return array;
    
}

+(NSString *)splitDictionaryToString:(NSDictionary *)dictionary{

    NSString *para = @"";
    if (dictionary == nil) {
        return para;
    }

    NSArray *valueArray = [dictionary allValues];
    NSArray *keyArray = [dictionary allKeys];

    for (int i = 0; i < dictionary.count; i++) {
        
        if (i == (dictionary.count - 1)) {
            para = [para stringByAppendingString:[NSString stringWithFormat:@"%@=%@",keyArray[i],valueArray[i]]];
        }else{
            para = [para stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",keyArray[i],valueArray[i]]];
        }
        
    }

    return para;

}

+(UIViewController *)parentController:(UIView *)view{

    for (UIView *next = [view superview] ; next ; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    abort();

}

+(NSDictionary *)urlAnalysisWithString:(NSString *)url{

    NSURL *urlBase = [NSURL URLWithString:url];

    //1.先按照‘&’拆分字符串
    NSArray *array = [urlBase.query componentsSeparatedByString:@"&"];
    //2.初始化两个可变数组
    NSMutableArray *mutArrayKey = [[NSMutableArray alloc]init];
    NSMutableArray *mutArrayValue = [[NSMutableArray alloc]init];
    //3.以拆分的数组内容个数为准继续拆分数组，并将拆分的元素分别存到两个可变数组中
    for (int i=0; i<[array count]; i++) {
        NSArray *arr = [array[i] componentsSeparatedByString:@"="];
        [mutArrayKey addObject:arr[0]];
        [mutArrayValue addObject:arr[1]];
    }
    //4.初始化一个可变字典，并设置键值对
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:mutArrayValue forKeys:mutArrayKey];

    return @{@"scheme":urlBase.scheme?:@"",
             @"host":urlBase.host?:@"",
             @"port":urlBase.port?:@"",
             @"path":urlBase.path?:@"",
             @"query":dict};

}

+(CAGradientLayer *)vGradientLayerWithFrame:(CGRect)frame{

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[self colorWithHexString:@"#528bfd" alpha:1].CGColor,
                             (__bridge id)[self colorWithHexString:@"#35b1ff" alpha:1].CGColor,
                             (__bridge id)[self colorWithHexString:@"#3cb7fd" alpha:1].CGColor];
    gradientLayer.locations = @[@0.1, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    return gradientLayer;

}

+(CAGradientLayer *)hGradientLayerWithFrame:(CGRect)frame{

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[self colorWithHexString:@"#528bfd" alpha:1].CGColor,
                             (__bridge id)[self colorWithHexString:@"#35b1ff" alpha:1].CGColor,
                             (__bridge id)[self colorWithHexString:@"#3cb7fd" alpha:1].CGColor];
    gradientLayer.locations = @[@0.1, @0.7, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 1.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    return gradientLayer;

}

+(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{

    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];

}

+(NSString *)lyCustomDateTypeWithDate:(NSString *)date type:(NSString *)type{

    //时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    //传入时间戳
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:[date intValue]];
    //返回结果
    return [dateFormatter stringFromDate:detaildate];

}

+(NSInteger)lyTimestampWithDate:(NSString *)date datetype:(NSString *)dateType{

    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //时间格式
    [formatter setDateFormat:dateType];
    //时间地区
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    //时间格式转成date
    NSDate *dDate = [formatter dateFromString:date];
    //时间转时间戳
    NSInteger timeSp = [[NSNumber numberWithDouble:[dDate timeIntervalSince1970]] integerValue];

    return timeSp;

}

+(CAShapeLayer *)superView:(UIView *)view corners:(UIRectCorner)corners radii:(CGSize)radii{

    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:view.bounds
                              byRoundingCorners:corners
                              cornerRadii:radii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;

}

+(BOOL)subStringWithText:(NSString *)text subString:(NSString *)string{

    if (text.length != 0) {
        NSString *subString = [text substringWithRange:NSMakeRange(0, string.length)];
        if ([subString isEqualToString:string]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }

}

+(NSMutableAttributedString *)lyASWithString:(NSString *)allString
                                      string:(NSArray *)stringArray
                                       color:(NSArray *)colorArray
                                        font:(NSArray *)fontArray{
    
    //设置属性化字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allString];
    
    if (stringArray.count != 0) {

        for (int i = 0; i < stringArray.count; i ++) {
            
            NSString *subString = stringArray[i];
            
            UIColor *subColor;
            if (stringArray.count != colorArray.count) {
                if (colorArray.count != 0) {
                    subColor = colorArray.firstObject;
                }else{
                    subColor = UIColor.blackColor;
                }
            }else{
                subColor = colorArray[i];
            }
            
            UIFont *subFont;
            if (stringArray.count != fontArray.count) {
                if (fontArray.count != 0) {
                    subFont = fontArray.firstObject;
                }else{
                    subFont = [UIFont systemFontOfSize:14.f];
                }
            }else{
                subFont = fontArray[i];
            }
            
            NSRange range = [[attributedString string] rangeOfString:subString];
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:subColor
                                     range:range];
            [attributedString addAttribute:NSFontAttributeName
                                     value:subFont
                                     range:range];
            
        }
        
    }

    //返回结果
    return attributedString;
    
}

+(CGFloat)lyASWithContent:(NSString *)content font:(id)font width:(float)width{

    //计算content高度
    CGFloat height = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:font}
                                           context:nil].size.height;
    return height;

}

+(CGFloat)lyASWithContent:(NSString *)content font:(id)font height:(float)height{

    //计算content宽度
    CGFloat width = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size.width;
    return width;

}

+(NSMutableAttributedString *)lyASWithString:(NSString *)allString subString:(NSString *)string color:(id)color{

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allString];
    NSRange range = [[attributedString string] rangeOfString:string];
    [attributedString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                             range:range];
    //选取变色字段
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:color
                             range:range];
    return attributedString;
    
}

+(NSString *)currentDate{

    NSString *format = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];

}

+(BOOL)validateWithEmail:(NSString *)email{
    NSString *regex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:email];
}


+(BOOL)validateWithMobile:(NSString *)mobile{
    NSString *phone = @"^1([3-9]\\d{9}$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phone];
    return [phoneTest evaluateWithObject:mobile];
}

+(NSString *)md5:(NSString *)string{

    //32位小写
    const char *input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;

    /*
    //32位大写
    const char *input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }

    return digest;
    */

    /*
    //16位小写
    NSString *md5Str = [self md5HashToLower32Bit];

    NSString *string;
    for (int i=0; i<24; i++) {
    string = [md5Str substringWithRange:NSMakeRange(8, 16)];
    }

    return string;
    */

    /*
    //16位大写
    NSString *md5Str = [self md5HashToUpper32Bit];

    NSString *string;
    for (int i=0; i<24; i++) {
    string = [md5Str substringWithRange:NSMakeRange(8, 16)];
    }

    return string;
     */

}

@end
