#import "LYPopupMenu.h"

#define MenuWindow [UIApplication sharedApplication].keyWindow
#define MenuScreenWidth [UIScreen mainScreen].bounds.size.width
#define MenuScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - ViewFrame
@interface UIView (ViewFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;

@end

@implementation UIView (ViewFrame)

-(CGFloat)x{
    return self.frame.origin.x;
}

-(void)setX:(CGFloat)value{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setY:(CGFloat)value{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

-(CGPoint)origin{
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerY{
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGSize)size{
    return self.frame.size;
}

-(void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

#pragma mark - Cell
@interface LYPopupMenuCell : UITableViewCell

@property (nonatomic) BOOL isShowSeparator;
@property (nonatomic, strong) UIColor *separatorColor;

@end

@implementation LYPopupMenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isShowSeparator = YES;
        _separatorColor = [UIColor lightGrayColor];
        [self setNeedsDisplay];
    }
    return self;
    
}

-(void)setIsShowSeparator:(BOOL)isShowSeparator{
    _isShowSeparator = isShowSeparator;
    [self setNeedsDisplay];
}

-(void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    
    if (!_isShowSeparator) {
        return;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5)];
    [_separatorColor setFill];
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:1];
    [bezierPath closePath];
    
}

@end

#pragma mark - LYPopupMenu
@interface LYPopupMenu ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic) CGFloat arrowHeight;
@property (nonatomic) CGFloat arrowWidth;
@property (nonatomic) CGFloat arrowPosition;
@property (nonatomic) CGFloat rowHeight;

@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic, strong) UIColor *separatorColor;

@end

@implementation LYPopupMenu

@synthesize cornerRadius = kCornerRadius;

-(instancetype)initWithTitles:(NSArray *)titles icons:(NSArray *)icons width:(CGFloat)width delegate:(id<LYPopupMenuDelegate>)delegate{
    
    self = [super init];
    if (self) {
        
        self.arrowHeight = 10;
        self.arrowWidth = 15;
        self.rowHeight = 44;
        kCornerRadius = 5.0;
        self.dismissOnSelected = YES;
        self.fontSize = 15.0;
        self.textColor = [UIColor blackColor];
        self.offset = 0.0;
        self.type = LYPopupMenuTypeDefault;
        self.contentColor = [UIColor whiteColor];
        self.separatorColor = [UIColor lightGrayColor];
        
        self.titles = titles;
        self.icons  = icons;
        
        self.width = width;
        self.height = (titles.count > 5 ? 5 * self.rowHeight : titles.count * self.rowHeight) + 2 * self.arrowHeight;
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        self.arrowPosition = 0.5 * self.width - 0.5 * self.arrowWidth;
        
        self.alpha = 0;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 2.0;
        
        [self addSubview:self.mainView];
        [self.mainView addSubview:self.tvList];
        
    }
    return self;
}

+(instancetype)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons width:(CGFloat)width delegate:(id<LYPopupMenuDelegate>)delegate{
    
    LYPopupMenu *menu = [[LYPopupMenu alloc] initWithTitles:titles icons:icons width:width delegate:delegate];
    [menu showAtPoint:point];
    return menu;
    
}

+(instancetype)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons width:(CGFloat)width delegate:(id<LYPopupMenuDelegate>)delegate{
    
    LYPopupMenu *menu = [[LYPopupMenu alloc] initWithTitles:titles icons:icons width:width delegate:delegate];
    [menu showRelyOnView:view];
    return menu;
    
}

-(void)showAtPoint:(CGPoint)point{
    _mainView.layer.mask = [self getMaskLayerWithPoint:point];
    [self show];
}

-(void)showRelyOnView:(UIView *)view{
    
    CGRect rect = [view convertRect:view.bounds toView:MenuWindow];
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height);
    _mainView.layer.mask = [self getMaskLayerWithPoint:point];
    if (self.y < _anchorPoint.y) {
        self.y -= rect.size.height;
    }
    [self show];
    
}

-(void)dismiss{
    
    __weak typeof(self) selfWeak = self;
    [UIView animateWithDuration: 0.25 animations:^{
        selfWeak.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        selfWeak.alpha = 0;
        selfWeak.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        selfWeak.delegate = nil;
        [selfWeak removeFromSuperview];
        [selfWeak.bgView removeFromSuperview];
    }];
    
}

#pragma mark - 创建MainView
-(UIView *)mainView{
    
    if (!_mainView) {
        _mainView = [[UIView alloc]initWithFrame:self.bounds];
        _mainView.backgroundColor = self.contentColor;
        _mainView.layer.cornerRadius = kCornerRadius;
        _mainView.layer.masksToBounds = YES;
    }
    return _mainView;
    
}

#pragma mark - 创建TableView
-(UITableView *)tvList{
    
    if (!_tvList) {
        _tvList = [[UITableView alloc] initWithFrame: self.mainView.bounds style:UITableViewStylePlain];
        _tvList.backgroundColor = [UIColor clearColor];
        _tvList.delegate = self;
        _tvList.dataSource= self;
        _tvList.bounces = self.titles.count > 5 ? YES : NO;
        _tvList.tableFooterView = [UIView new];
        _tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tvList.height -= 2 * self.arrowHeight;
        _tvList.centerY = self.mainView.centerY;
    }
    return _tvList;
    
}

#pragma mark tableViewDelegate & dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ident = @"Cell";
    LYPopupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[LYPopupMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = _textColor;
    cell.textLabel.font = [UIFont systemFontOfSize:_fontSize];
    cell.textLabel.text = _titles[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.separatorColor = _separatorColor;
    
    if (_icons.count >= indexPath.row + 1) {
        if ([_icons[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.imageView.image = [UIImage imageNamed:_icons[indexPath.row]];
        }else if ([_icons[indexPath.row] isKindOfClass:[UIImage class]]){
            cell.imageView.image = _icons[indexPath.row];
        }else {
            cell.imageView.image = nil;
        }
    }else {
        cell.imageView.image = nil;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dismissOnSelected) {
        [self dismiss];
    }
    
    if ([_delegate respondsToSelector:@selector(popupMenuDidselectedWithIndex:menu:)]) {
        [_delegate popupMenuDidselectedWithIndex:indexPath.row menu:self];
    }
    
}

#pragma mark - scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    LYPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    LYPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
}

-(LYPopupMenuCell *)getLastVisibleCell{
    
    NSArray <NSIndexPath *>*indexPaths = [_tvList indexPathsForVisibleRows];
    indexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.row < obj2.row;
    }];
    NSIndexPath *indexPath = indexPaths.firstObject;
    return [_tvList cellForRowAtIndexPath:indexPath];
    
}

#pragma mark - 创建手势背景
-(UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.alpha = 0;
        _bgView.tag = 10000;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
    
}

#pragma mark private functions
-(void)setType:(LYPopupMenuType)type{
    
    _type = type;
    switch (type) {
        case LYPopupMenuTypeDark:
        {
            _textColor = [UIColor lightGrayColor];
            _contentColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.29 alpha:1];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
            
        default:
        {
            _textColor = [UIColor blackColor];
            _contentColor = [UIColor whiteColor];
            _separatorColor = [UIColor lightGrayColor];
        }
            break;
    }
    _mainView.backgroundColor = _contentColor;
    [_tvList reloadData];
    
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    [_tvList reloadData];
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [_tvList reloadData];
}

-(void)setDismissOnTouchOutside:(BOOL)dismissOnTouchOutside{
    _dismissOnSelected = dismissOnTouchOutside;
    if (!dismissOnTouchOutside) {
        for (UIGestureRecognizer *gr in _bgView.gestureRecognizers) {
            [_bgView removeGestureRecognizer:gr];
        }
    }
}

-(void)setIsShowShadow:(BOOL)isShowShadow{
    _isShowShadow = isShowShadow;
    if (!isShowShadow) {
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0.0;
    }
}

-(void)setOffset:(CGFloat)offset{
    _offset = offset;
    if (offset < 0) {
        offset = 0.0;
    }
    self.y += self.y >= _anchorPoint.y ? offset : -offset;
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    kCornerRadius = cornerRadius;
    _mainView.layer.mask = [self drawMaskLayer];
    if (self.y < _anchorPoint.y) {
        _mainView.layer.mask.affineTransform = CGAffineTransformMakeRotation(M_PI);
    }
}

-(void)show{
    
    __weak typeof(self) selfWeak = self;
    [[MenuWindow viewWithTag:10000] removeFromSuperview];
    [MenuWindow addSubview:self.bgView];
    [MenuWindow addSubview:self];
    LYPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        selfWeak.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        selfWeak.alpha = 1;
        selfWeak.bgView.alpha = 1;
    }];
    
}

-(void)setAnimationAnchorPoint:(CGPoint)point{
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}

-(void)determineAnchorPoint{
    
    CGPoint aPoint;
    if (CGRectGetMaxY(self.frame) > MenuScreenHeight) {
        aPoint = CGPointMake(fabs(self.arrowPosition) / self.width, 1);
    }else {
        aPoint = CGPointMake(fabs(self.arrowPosition) / self.width, 0);
    }
    [self setAnimationAnchorPoint:aPoint];
    
}

-(CAShapeLayer *)getMaskLayerWithPoint:(CGPoint)point{
    
    [self setArrowPointingWhere:point];
    CAShapeLayer *layer = [self drawMaskLayer];
    [self determineAnchorPoint];
    if (CGRectGetMaxY(self.frame) > MenuScreenHeight) {
        self.arrowPosition = self.width - self.arrowPosition - self.arrowWidth;
        layer = [self drawMaskLayer];
        layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
        self.y = _anchorPoint.y - self.height;
    }
    self.y += self.y >= _anchorPoint.y ? _offset : -_offset;
    return layer;
    
}

-(void)setArrowPointingWhere:(CGPoint)anchorPoint{
    
    _anchorPoint = anchorPoint;
    
    self.x = anchorPoint.x - self.arrowPosition - 0.5 * self.arrowWidth;
    self.y = anchorPoint.y;
    
    CGFloat maxX = CGRectGetMaxX(self.frame);
    CGFloat minX = CGRectGetMinX(self.frame);
    
    if (maxX > MenuScreenWidth - 10) {
        self.x = MenuScreenWidth - 10 - self.width;
    }else if (minX < 10) {
        self.x = 10;
    }
    
    maxX = CGRectGetMaxX(self.frame);
    minX = CGRectGetMinX(self.frame);
    
    if ((anchorPoint.x <= maxX - kCornerRadius) && (anchorPoint.x >= minX + kCornerRadius)) {
        self.arrowPosition = anchorPoint.x - minX - 0.5 * self.arrowWidth;
    }else if (anchorPoint.x < minX + kCornerRadius) {
        self.arrowPosition = kCornerRadius;
    }else {
        self.arrowPosition = self.width - kCornerRadius - self.arrowWidth;
    }
    
}

-(CAShapeLayer *)drawMaskLayer{
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _mainView.bounds;
    
    CGFloat centerTopLeft = self.width - kCornerRadius;
    CGFloat centerTopRight = self.arrowHeight + kCornerRadius;
    
    CGPoint topRight = CGPointMake(centerTopLeft, centerTopRight);
    CGPoint topLeft = CGPointMake(kCornerRadius, centerTopRight);
    
    CGFloat centerBottomRight = self.height - self.arrowHeight;
    
    CGPoint bottomRight = CGPointMake(centerTopLeft, centerBottomRight - kCornerRadius);
    CGPoint bottomLeft = CGPointMake(kCornerRadius, centerBottomRight - kCornerRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, centerTopRight)];
    [path addLineToPoint:CGPointMake(0, bottomLeft.y)];
    [path addArcWithCenter:bottomLeft radius:kCornerRadius startAngle:-M_PI endAngle:-M_PI - M_PI_2 clockwise:NO];
    [path addLineToPoint:CGPointMake(centerTopLeft, centerBottomRight)];
    [path addArcWithCenter:bottomRight radius:kCornerRadius startAngle:-M_PI - M_PI_2 endAngle:-M_PI * 2 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.width, centerTopRight)];
    [path addArcWithCenter:topRight radius:kCornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.arrowPosition + self.arrowWidth, self.arrowHeight)];
    [path addLineToPoint:CGPointMake(self.arrowPosition + 0.5 * self.arrowWidth, 0)];
    [path addLineToPoint:CGPointMake(self.arrowPosition, self.arrowHeight)];
    [path addLineToPoint:CGPointMake(kCornerRadius, self.arrowHeight)];
    [path addArcWithCenter:topLeft radius:kCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
    [path closePath];
    
    maskLayer.path = path.CGPath;
    return maskLayer;
    
}

@end
