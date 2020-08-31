#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYTools : NSObject

/**
 对象转字符串
 */
+(NSString *)idToJsonString:(id)object;

/**
 json字符串转对象
 */
+(id)jsonStringToIDs:(NSString *)jString;

/**
 字典转数组
 */
+(NSArray *)dictionaryToArray:(NSDictionary *)dictionary;

/**
 拆分字典元素拼成字符串
 */
+(NSString *)splitDictionaryToString:(NSDictionary *)dictionary;

/**
 subView获取superView
 */
+(UIViewController *)parentController:(UIView *)view;

/**
 URL解析
 */
+(NSDictionary *)urlAnalysisWithString:(NSString *)url;

/**
 垂直渐变
 */
+(CAGradientLayer *)vGradientLayerWithFrame:(CGRect)frame;

/**
 水平渐变
 */
+(CAGradientLayer *)hGradientLayerWithFrame:(CGRect)frame;

/**
 十六进制颜色转换
 */
+(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 按照格式返回时间
 */
+(NSString *)lyCustomDateTypeWithDate:(NSString *)date type:(NSString *)type;

/**
 时间格式转时间戳
 */
+(NSInteger)lyTimestampWithDate:(NSString *)date datetype:(NSString *)dateType;

/**
 圆角处理
 
 @param view 需要圆角化的视图
 @param corners 需要圆角的边角
 @param radii 需要圆角的尺寸
 @return CAShapeLayer
 */
+(CAShapeLayer *)superView:(UIView *)view corners:(UIRectCorner)corners radii:(CGSize)radii;

/**
 判断字符串首字符是否为指定字符串
 */
+(BOOL)subStringWithText:(NSString *)text subString:(NSString *)string;

/**
 修改字符串字体颜色和字号
 */

+(NSMutableAttributedString *)lyASWithString:(NSString *)allString
                                      string:(NSArray *)stringArray
                                       color:(NSArray *)colorArray
                                        font:(NSArray *)fontArray;

/**
 计算高度
 */
+(CGFloat)lyASWithContent:(NSString *)content font:(id)font width:(float)width;

/**
 计算宽度
 */
+(CGFloat)lyASWithContent:(NSString *)content font:(id)font height:(float)height;

/**
 添加下划线
 */
+(NSMutableAttributedString *)lyASWithString:(NSString *)allString subString:(NSString *)string color:(id)color;

/**
 获取当前时间
 */
+(NSString *)currentDate;

/**
 判断邮箱格式
 */
+(BOOL)validateWithEmail:(NSString *)email;

/**
判断手机号码格式
*/
+(BOOL)validateWithMobile:(NSString *)mobile;

/**
 MD5加密
 */
+(NSString *)md5:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
