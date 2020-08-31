#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , LYPopupMenuType) {
    LYPopupMenuTypeDefault = 0,
    LYPopupMenuTypeDark
};

@class LYPopupMenu;

@protocol LYPopupMenuDelegate <NSObject>

-(void)popupMenuDidselectedWithIndex:(NSInteger)index menu:(LYPopupMenu *)menu;

@end

@interface LYPopupMenu : UIView

/**
 内容数组
 */
@property (nonatomic, strong) NSArray *titles;

/**
 圆角半径 Default is 5.0
 */
@property (nonatomic) CGFloat cornerRadius;

/**
 是否显示阴影 Default is YES
 */
@property (nonatomic, getter=isShadowShowing) BOOL isShowShadow;

/**
 选择菜单项后消失 Default is YES
 */
@property (nonatomic) BOOL dismissOnSelected;

/**
 点击菜单外消失  Default is YES
 */
@property (nonatomic) BOOL dismissOnTouchOutside;

/**
 设置字体大小 Default is 15
 */
@property (nonatomic) CGFloat fontSize;

/**
 设置字体颜色 Default is [UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 设置偏移距离 (>= 0) Default is 0.0
 */
@property (nonatomic) CGFloat offset;

/**
 设置显示模式 Default is LYPopupMenuTypeDefault
 */
@property (nonatomic) LYPopupMenuType type;

/**
 代理
 */
@property (nonatomic, weak) id<LYPopupMenuDelegate> delegate;

/**
 初始化popupMenu
 */
-(instancetype)initWithTitles:(NSArray *)titles icons:(nullable NSArray *)icons width:(CGFloat)width delegate:(id<LYPopupMenuDelegate>)delegate;

/**
 在指定位置弹出类方法
 */
+(instancetype)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons width:(CGFloat)width delegate:(id<LYPopupMenuDelegate>)delegate;


/**
  依赖指定view弹出类方法
 */
+(instancetype)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons width:(CGFloat)width delegate:(id<LYPopupMenuDelegate>)delegate;


/**
 在指定位置弹出

 @param point 需要弹出的point位置
 */
-(void)showAtPoint:(CGPoint)point;


/**
 依赖指定view弹出

 @param view 需要依赖的view
 */
-(void)showRelyOnView:(UIView *)view;

/**
 消失
 */
-(void)dismiss;

@end

NS_ASSUME_NONNULL_END
