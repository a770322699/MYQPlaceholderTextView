//
//  MYQPlaceholderTextView.m
//  MYQPlaceholderTextViewDemo
//
//  Created by maygolf on 16/6/6.
//  Copyright © 2016年 yiquan. All rights reserved.
//

IB_DESIGNABLE

#import "MYQPlaceholderTextView.h"
#import "Masonry.h"

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

@interface MYQPlaceholderTextView ()

@property (nonatomic, strong) UITextView *placeholderTextView;

@end

@implementation MYQPlaceholderTextView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"text"];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self step];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    self.placeholderTextView.font = self.font;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self step];
}

- (void)step{
    [self addSubview:self.placeholderTextView];
    [self.placeholderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.top.equalTo(@0);
        make.height.lessThanOrEqualTo(self);
        make.width.lessThanOrEqualTo(self);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - getter
- (UITextView *)placeholderTextView{
    if (!_placeholderTextView) {
        _placeholderTextView = [[UITextView alloc] initWithFrame:self.bounds];
        _placeholderTextView.backgroundColor = [UIColor clearColor];
        _placeholderTextView.userInteractionEnabled = NO;
        _placeholderTextView.textColor = [UIColor lightGrayColor];
        _placeholderTextView.translatesAutoresizingMaskIntoConstraints = NO;
        _placeholderTextView.scrollEnabled = NO;
        //_placeholderTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _placeholderTextView;
}
#pragma mark - setting
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self textDidChanged];
}

#pragma mark - private
- (void)textDidChanged{
    BOOL disPlayPlaceholder = self.text.length == 0;
    self.placeholderTextView.hidden = !disPlayPlaceholder;
    if (disPlayPlaceholder) {
        self.placeholderTextView.font = self.font;
        self.placeholderTextView.text = self.placeholder;
    }else{
        self.placeholderTextView.text = nil;
    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self textDidChanged];
}

@end
