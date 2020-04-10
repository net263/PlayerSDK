//
//  GSChatToolBar.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/17.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSChatToolBar.h"
#import "GSFaceView.h"
#import "GSTextAttachment.h"
#import "UIView+GSSetRect.h"

#define UICOLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
#pragma mark - GSChatToolBarItem

@implementation GSChatToolbarItem

- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)linkView
{
    self = [super init];
    if (self) {
        _button = button;
        _linkView = linkView;
    }

    return self;
}

@end

#pragma mark - GSTextView

@implementation GSTextView

- (void)setPlaceHolder:(NSString *)placeHolder {
    if([placeHolder isEqualToString:_placeHolder]) {
        return;
    }

    NSUInteger maxChars = 33;
    if([placeHolder length] > maxChars) {
        placeHolder = [placeHolder substringToIndex:maxChars - 8];
        placeHolder = [[placeHolder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
    }

    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    if([placeHolderTextColor isEqual:_placeHolderTextColor]) {
        return;
    }

    _placeHolderTextColor = placeHolderTextColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    if (text.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = self.textAlignment;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                     NSFontAttributeName:self.font?self.font:[UIFont systemFontOfSize:15.f],
                                     NSForegroundColorAttributeName:self.textColor};
        
        
        self.attributedText = [[NSAttributedString alloc]initWithString:self.text attributes:attributes];
    }
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    [self setNeedsDisplay];
}

#pragma mark - Life cycle

- (void)setup {
    self.accessibilityIdentifier = @"text_view";

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];

    _placeHolderTextColor = [UIColor lightGrayColor];

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 8.0f);
//    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
//    self.contentInset = UIEdgeInsetsMake(0.5, 0, 0, 0.5);
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont systemFontOfSize:15.f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;
    self.textAlignment = NSTextAlignmentLeft;
    

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    _placeHolder = nil;
    _placeHolderTextColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    if([self.text length] == 0 && self.placeHolder) {
        CGRect placeHolderRect = CGRectMake(10.0f,
                                            7.0f,
                                            rect.size.width,
                                            rect.size.height);

        [self.placeHolderTextColor set];

        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_0) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = self.textAlignment;

            [self.placeHolder drawInRect:placeHolderRect
                          withAttributes:@{ NSFontAttributeName : self.font,
                                            NSForegroundColorAttributeName : self.placeHolderTextColor,
                                            NSParagraphStyleAttributeName : paragraphStyle }];
        }
        else {
            [self.placeHolder drawInRect:placeHolderRect
                                withFont:self.font
                           lineBreakMode:NSLineBreakByTruncatingTail
                               alignment:self.textAlignment];
        }
    }
}



@end

#pragma mark - GSChatToolBar


@interface GSChatToolBar () <UITextViewDelegate, GSFaceDelegate>
@property (nonatomic) CGFloat version;
@property (strong, nonatomic) NSMutableArray *leftItems;
@property (strong, nonatomic) NSMutableArray *rightItems;
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) GSChatToolbarItem *sendItem;
@property (strong, nonatomic) UIButton *faceButton;
@property (nonatomic) CGFloat previousTextViewContentHeight;//上一次inputTextView的contentSize.height


@property (nonatomic, readonly) CGFloat inputViewMaxHeight;

@property (nonatomic, readonly) CGFloat inputViewMinHeight;

@property (nonatomic, readonly) CGFloat horizontalPadding;

@property (nonatomic, readonly) CGFloat verticalPadding;



@property (strong, nonatomic) UIView *textBack;
@end

@implementation GSChatToolBar
{
    NSLayoutConstraint* _heightCons;
    CGFloat _height_oneRowText;//输入框每一行文字高度
}
@synthesize faceView = _faceView;
@synthesize moreView = _moreView;


- (instancetype)initWithFrame:(CGRect)frame

{

    self = [self initWithFrame:frame horizontalPadding:4 verticalPadding:4 inputViewMinHeight:32 inputViewMaxHeight:80];

    if (self) {

    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight

{
    if (frame.size.height < (verticalPadding * 2 + inputViewMinHeight)) {
        frame.size.height = verticalPadding * 2 + inputViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.accessibilityIdentifier = @"chatbar";

        _horizontalPadding = horizontalPadding;
        _verticalPadding = verticalPadding;
        _inputViewMinHeight = inputViewMinHeight;
        _inputViewMaxHeight = inputViewMaxHeight;


        _leftItems = [NSMutableArray array];
        _rightItems = [NSMutableArray array];
        _version = [[[UIDevice currentDevice] systemVersion] floatValue];
        _activityButtomView = nil;
        _isShowButtomView = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

        [self _setupSubviews];
        
        _editable = YES;
    }
    return self;
}

- (void)_setupSubviews
{
    
    
    
    //backgroundImageView
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _backgroundImageView.backgroundColor = [UIColor clearColor];
//    _backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    _backgroundImageView.backgroundColor = UICOLOR16(0xeff0f3);
    [self addSubview:_backgroundImageView];
    
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    
    
    
    
    //toolbar
    _toolbarView = [[UIView alloc] initWithFrame:self.bounds];
    _toolbarView.backgroundColor = [UIColor clearColor];
    [self addSubview:_toolbarView];
    
    _toolbarView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbarView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbarView)]];

    NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[_toolbarView(%f)]",self.bounds.size.height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbarView)];

    _heightCons = [array lastObject];

    [self addConstraints:array];
    
    _line = [UIView new];
    _line.backgroundColor = UICOLOR16(0xd7d7d7);
    [_toolbarView addSubview:_line];
    
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    [_toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_line]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line)]];
    [_toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_line(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_line)]];

    _toolbarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _toolbarView.frame.size.width, _toolbarView.frame.size.height)];
//    _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
    [_toolbarView addSubview:_toolbarBackgroundImageView];

    _toolbarBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_line][_toolbarBackgroundImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbarBackgroundImageView,_line)]];
    [_toolbarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbarBackgroundImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbarBackgroundImageView)]];
    
    //input textview
    _inputTextView = [[GSTextView alloc] initWithFrame:CGRectMake(self.horizontalPadding, self.verticalPadding, self.frame.size.width - self.verticalPadding * 2, self.frame.size.height - self.verticalPadding * 2)];
    _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 2.0f;
    _previousTextViewContentHeight = [self _getTextViewContentH:_inputTextView];
    [_toolbarView addSubview:_inputTextView];
    
//    _height_oneRowText = [_inputTextView.layoutManager usedRectForTextContainer:_inputTextView.textContainer].size.height + 10;//输入框每一行文字高度

  
    
    //emoji
    self.faceButton = [[UIButton alloc] init];
    
    self.faceButton.accessibilityIdentifier = @"face";
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    [self.faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"face_HL"] forState:UIControlStateHighlighted];
    [self.faceButton setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
//    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(faceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    GSChatToolbarItem *faceItem = [[GSChatToolbarItem alloc] initWithButton:self.faceButton withView:self.faceView];


    //more
    self.sendButton = [[UIButton alloc] init];
    self.sendButton.bounds = CGRectMake(0, 0, 40, self.toolbarView.frame.size.height - self.verticalPadding * 2);
    self.sendButton.accessibilityIdentifier = @"send";
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
//    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
//    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_moreSelected"] forState:UIControlStateHighlighted];
//    [self.moreButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
    [self.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sendButton setTitleColor:UICOLOR16(0x4D4D4D) forState:UIControlStateNormal];
    _sendItem = [[GSChatToolbarItem alloc] initWithButton:self.sendButton withView:nil];

//    [self setInputViewRightItems:@[faceItem, moreItem]];
    
    [self setInputViewRightItems:@[faceItem]];
}

- (void)setEmotionHide:(BOOL)isHide{
    
    if (isHide) {
        [self setInputViewRightItems:nil];
    }else{
        GSChatToolbarItem *faceItem = [[GSChatToolbarItem alloc] initWithButton:self.faceButton withView:self.faceView];
        
        [self setInputViewRightItems:@[faceItem]];
    }
    
}


- (void)setInputViewLeftItems:(NSArray *)inputViewLeftItems
{
    for (GSChatToolbarItem *item in self.leftItems) {
        [item.button removeFromSuperview];
        [item.linkView removeFromSuperview];
    }
    [self.leftItems removeAllObjects];
    
    CGFloat oX = self.horizontalPadding;
    CGFloat itemHeight = self.toolbarView.frame.size.height - self.verticalPadding * 2;

    for (id item in inputViewLeftItems) {
        if ([item isKindOfClass:[GSChatToolbarItem class]]) {
            GSChatToolbarItem *chatItem = (GSChatToolbarItem *)item;
            if (chatItem.button) {
                CGRect itemFrame = chatItem.button.frame;
                if (itemFrame.size.height == 0) {
                    itemFrame.size.height = itemHeight;
                }
                
                if (itemFrame.size.width == 0) {
                    itemFrame.size.width = itemFrame.size.height;
                }
                
                itemFrame.origin.x = oX;
                itemFrame.origin.y = (self.toolbarView.frame.size.height - itemFrame.size.height) / 2;
                chatItem.button.frame = itemFrame;
                oX += (itemFrame.size.width + self.horizontalPadding);
                
                [self.toolbarView addSubview:chatItem.button];
                [self.leftItems addObject:chatItem];
            }
        }
    }
    
    CGRect inputFrame = self.inputTextView.frame;
    CGFloat value = inputFrame.origin.x - oX;
    inputFrame.origin.x = oX;
    inputFrame.size.width += value;
    self.inputTextView.frame = inputFrame;
    
//    CGRect recordFrame = self.recordButton.frame;
//    recordFrame.origin.x = inputFrame.origin.x;
//    recordFrame.size.width = inputFrame.size.width;
//    self.recordButton.frame = recordFrame;
}

- (void)setInputViewRightItems:(NSArray *)inputViewRightItems
{
    for (GSChatToolbarItem *item in self.rightItems) {
        [item.button removeFromSuperview];
        [item.linkView removeFromSuperview];
    }
    [self.rightItems removeAllObjects];

    CGFloat oMaxX = self.toolbarView.frame.size.width - self.horizontalPadding;
    CGFloat itemHeight = self.toolbarView.frame.size.height - self.verticalPadding * 2;
    
    NSMutableArray *rightItems = [NSMutableArray arrayWithArray:inputViewRightItems];
    [rightItems addObject:_sendItem];
    
    if ([rightItems count] > 0) {
        for (NSInteger i = (rightItems.count - 1); i >= 0; i--) {
            id item = [rightItems objectAtIndex:i];
            if ([item isKindOfClass:[GSChatToolbarItem class]]) {
                GSChatToolbarItem *chatItem = (GSChatToolbarItem *)item;
                if (chatItem.button) {
                    CGRect itemFrame = chatItem.button.frame;
                    if (itemFrame.size.height == 0) {
                        itemFrame.size.height = itemHeight;
                    }

                    if (itemFrame.size.width == 0) {
                        itemFrame.size.width = itemFrame.size.height;
                    }

                    oMaxX -= itemFrame.size.width;
                    itemFrame.origin.x = oMaxX;
                    itemFrame.origin.y = (self.toolbarView.frame.size.height - itemFrame.size.height) / 2;
                    chatItem.button.frame = itemFrame;
                    oMaxX -= self.horizontalPadding;

                    [self.toolbarView addSubview:chatItem.button];
                    [self.rightItems addObject:item];
                }
            }
        }
    }

    CGRect inputFrame = self.inputTextView.frame;
    CGFloat value = oMaxX - CGRectGetMaxX(inputFrame);
    inputFrame.size.width += value;
    self.inputTextView.frame = inputFrame;

    
    
    
//    _inputTextView.contentInset = UIEdgeInsetsMake(0, _inputTextView.height/2 - 2, 0, 0);
//    [self.toolbarView insertSubview:textBack atIndex:1];

}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    
    _inputTextView.editable = editable;
    
    
    for (GSChatToolbarItem *item in self.rightItems) {
        item.button.userInteractionEnabled = editable;
    }
    
//    for (GSChatToolbarItem *item in self.leftItems) {
//        item.button.userInteractionEnabled = editable;
//    }
    
}


//使用黑色主题 并且关闭主题控制
- (void)usingBlackStyle{
    
    _line.backgroundColor = UICOLOR16(0x1a1a1a);
    _backgroundImageView.backgroundColor = UICOLOR16(0x242424);
//    [_inputTextView setTextColor:FASTSDK_COLOR16(0xFFFFFF)];
    [_sendButton setTitleColor:UICOLOR16(0xffffff) forState:UIControlStateNormal];
    [_textBack setBackgroundColor:UICOLOR16(0x393939)];
    [_textBack.layer setBorderColor:UICOLOR16(0x1a1a1a).CGColor];
    [_inputTextView setTextColor:UICOLOR16(0xffffff)];
    
}

#pragma mark - getter


- (UIView *)faceView
{
    if (_faceView == nil) {
        _faceView = [[GSFaceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 180)];
//        _faceView = [[EaseFaceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 180)];
        [(GSFaceView *)_faceView setDelegate:self];
        _faceView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
//        [_faceView setZh_backgroundColorPicker:TMColorWithKey(GSThemeColorKeyboardBack)];
//        _faceView.backgroundColor = [UIColor whiteColor];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _faceView;
}

- (UIView *)moreView
{
    if (_moreView == nil) {
//        _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 80)];
////        _moreView = [[EaseChatBarMoreView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbarView.frame), self.frame.size.width, 80) type:self.chatBarType];
//        _moreView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0];
//        _moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _moreView;
}

#pragma mark - setter

- (void)setMoreView:(UIView *)moreView
{
    if (_moreView != moreView) {
        _moreView = moreView;
        
        for (GSChatToolbarItem *item in self.rightItems) {
            if (item.button == self.moreButton) {
                item.linkView = _moreView;
                break;
            }
        }
    }
}

- (void)setFaceView:(UIView *)faceView
{
    if (_faceView != faceView) {
        _faceView = faceView;
        
        for (GSChatToolbarItem *item in self.rightItems) {
            if (item.button == self.faceButton) {
                item.linkView = _faceView;
                break;
            }
        }
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }

//    for (GSChatToolbarItem *item in self.leftItems) {
//        item.button.selected = NO;
//    }

    for (GSChatToolbarItem *item in self.rightItems) {
        item.button.selected = NO;
    }

    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];

    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.attributedText.string];
            self.inputTextView.text = @"";
            [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];
        }

        return NO;
    }
//    else if ([text isEqualToString:@"@"]) { // @我们暂时不需要处理
//        if ([self.delegate respondsToSelector:@selector(didInputAtInLocation:)]) {
//            if ([self.delegate didInputAtInLocation:range.location]) {
//                [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];
//                return NO;
//            }
//        }
//    }
//    else if ([text length] == 0) {
        //delete one character
//        if (range.length == 1 && [self.delegate respondsToSelector:@selector(didDeleteCharacterFromLocation:)]) {
//            return ![self.delegate didDeleteCharacterFromLocation:range.location];
//        }
//    }
    else if ([text isEqualToString:@""] || [text length] == 0) {
        //delete emotion
        [self deleteEmoticon];
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self _willShowInputTextViewToHeight:[self _getTextViewContentH:textView]];
}

- (void)deleteEmoticon{
    
    NSRange range = self.inputTextView.selectedRange;
    NSInteger location = (NSInteger)range.location;
    if (location == 0) {
        if (range.length) {
            self.inputTextView.text = @"";
        }
        return ;
    }
    //判断是否表情
    NSString *subString = [self.inputTextView.text substringToIndex:location];
    if ([subString hasSuffix:@"】"]) {
        
        //查询是否存在表情
        __block NSString *emoticon = nil;
        __block NSRange  emoticonRange;
        
        // 表情的规则
//        NSString *emotionPattern = @"\\【[a-zA-Z0-9\\u4e00-\\u9fa5]+\\】";
//
//        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\【[^ \\【\\】]+?\\】" options:kNilOptions error:NULL];
        
        [regex enumerateMatchesInString:subString options:kNilOptions range:NSMakeRange(0, subString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            emoticonRange = result.range;
            emoticon = [subString substringWithRange:result.range];
            
            
            
        }];
        
        if (emoticon) {
            
            NSArray *emotionArray = [[GSEmotionEscape sharedInstance].text2key allKeys];
            
            //是表情符号,移除
            if ([emotionArray containsObject:emoticon]) {
                
                self.inputTextView.text = [self.inputTextView.text stringByReplacingCharactersInRange:emoticonRange withString:@""];
                NSLog(@"要删除表情是：\n%@",emoticon);
                
                range.location -= emoticonRange.length;
//                range.length = 1;
                self.inputTextView.selectedRange = NSMakeRange(range.location, 0);;
                
            }else{
                [self.inputTextView deleteBackward];
            }
        }else{
            [self.inputTextView deleteBackward];
        }
        
    }else{
        [self.inputTextView deleteBackward];
    }
    
}

#pragma mark - UIKeyboardNotification

- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification
{
    
    if (self.faceButton.selected) {
        return;
    }
    
    if ([self.inputTextView isFirstResponder] || [self isFirstResponder] || [self.superview isFirstResponder]) {
//        GSLog(@"第一响应者:self.inputTextView:%d,self:%d,self.superview:%d",[self.inputTextView isFirstResponder],[self isFirstResponder],[self.superview isFirstResponder]);
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        void(^animations)() = ^{
            [self _willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
        };
        
        [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
    }
}
    
    

#pragma mark - action

- (void)styleButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        for (GSChatToolbarItem *item in self.rightItems) {
            item.button.selected = NO;
        }
        
        for (GSChatToolbarItem *item in self.leftItems) {
            if (item.button != button) {
                item.button.selected = NO;
            }
        }
        [UIView animateWithDuration:0.15 animations:^{
            [self _willShowBottomView:nil];
        }];
        
        
        self.inputTextView.text = @"";
        [self textViewDidChange:self.inputTextView];
        [self.inputTextView resignFirstResponder];
        
        if ([self.delegate respondsToSelector:@selector(didShowMyMessage:)]) {
            [self.delegate didShowMyMessage:YES];
        }
        
    }
    else{
        
        if ([self.delegate respondsToSelector:@selector(didShowMyMessage:)]) {
            [self.delegate didShowMyMessage:NO];
        }
//        [self.inputTextView becomeFirstResponder];
    }
    
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.recordButton.hidden = !button.selected;
//        self.inputTextView.hidden = button.selected;
//    } completion:nil];
}

- (void)faceButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    GSChatToolbarItem *faceItem = nil;
    for (GSChatToolbarItem *item in self.rightItems) {
        if (item.button == button){
            faceItem = item;
            continue;
        }
        
        item.button.selected = NO;
    }
    
//    for (GSChatToolbarItem *item in self.leftItems) {
//        item.button.selected = NO;
//    }
    
    if (button.selected) {
        [self.inputTextView resignFirstResponder];
        
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
            [self _willShowBottomView:faceItem.linkView];
        } completion:nil];
        
        
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.recordButton.hidden = button.selected;
//            self.inputTextView.hidden = !button.selected;
//        } completion:^(BOOL finished) {
//
//        }];
    } else {
        [self.inputTextView becomeFirstResponder];
    }
}

- (void)sendButtonAction:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:self.inputTextView.attributedText.string];
        self.inputTextView.text = @"";
        [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];
    }

//    UIButton *button = (UIButton *)sender;
//    button.selected = !button.selected;
    
//    GSChatToolbarItem *moreItem = nil;
//    for (GSChatToolbarItem *item in self.rightItems) {
//        if (item.button == button){
//            moreItem = item;
//            continue;
//        }
//
//        item.button.selected = NO;
//    }
    
//    for (GSChatToolbarItem *item in self.leftItems) {
//        item.button.selected = NO;
//    }
//
//    if (button.selected) {
//        [self.inputTextView resignFirstResponder];
//
//        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut animations:^{
//
//            [self _willShowBottomView:moreItem.linkView];
//
//        } completion:nil];
        
        
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.recordButton.hidden = button.selected;
//            self.inputTextView.hidden = !button.selected;
//        } completion:nil];
//    }
//    else
//    {
////        [self.inputTextView becomeFirstResponder];
//    }
}

#pragma mark - private input view

/*!
 @method
 @brief 获取textView的高度(实际为textView的contentSize的高度)
 @discussion
 @param textView 文本框
 @result
 */
- (CGFloat)_getTextViewContentH:(UITextView *)textView
{
    
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

/*!
 @method
 @brief 通过传入的toHeight，跳转toolBar的高度
 @discussion
 @param toHeight
 @result
 */
- (void)_willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < self.inputViewMinHeight) {
        toHeight = self.inputViewMinHeight;
    }
    if (toHeight > self.inputViewMaxHeight) {
        toHeight = self.inputViewMaxHeight;
    }

    if (toHeight == _previousTextViewContentHeight)
    {
        [self.inputTextView scrollRangeToVisible:self.inputTextView.selectedRange]; //确保输入换行时 不会错位
        return;
    }
    else{
        
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        
  
        _heightCons.constant += changeHeight;

        void(^animations)() = ^{
            
            CGRect rect = self.frame;
            rect.size.height += changeHeight;
            rect.origin.y -= changeHeight;
            self.frame = rect;
        
        
            _previousTextViewContentHeight = toHeight;
            
            if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
                [_delegate chatToolbarDidChangeFrameToHeight:self.frame.size.height];
            }
         
            [self layoutIfNeeded];

            
        };
        
        if (changeHeight > 0) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | (7 << 16) animations:animations completion:nil];
        }else{
            [UIView animateWithDuration:0.15 animations:animations];
        }
        
        //确保输入换行时 不会错位
        [self.inputTextView scrollRangeToVisible:self.inputTextView.selectedRange];
        
        
        
    }
}
#pragma mark - private bottom view

/*!
 @method
 @brief 调整toolBar的高度
 @discussion
 @param bottomHeight 底部菜单的高度
 @result
 */
- (void)_willShowBottomHeight:(CGFloat)bottomHeight
{
    
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);

    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }

    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
   
    self.frame = toFrame;

    
    if (_delegate && [_delegate respondsToSelector:@selector(chatToolbarDidChangeFrameToHeight:)]) {
        [_delegate chatToolbarDidChangeFrameToHeight:toHeight];
    }
}

/*!
 @method
 @brief 切换菜单视图
 @discussion
 @param bottomView 菜单视图
 @result
 */
- (void)_willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView] && bottomView) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self _willShowBottomHeight:bottomHeight];

        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
            
            bottomView.translatesAutoresizingMaskIntoConstraints = NO;

            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[bottomView]|"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomView)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[_toolbarView][bottomView(180)]"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomView,_toolbarView)]];
        }

        if (self.activityButtomView) {
            
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
        
        
    }else{
        if (bottomView) {
            CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
            [self _willShowBottomHeight:bottomHeight];
        }else{
            
            
            [self _willShowBottomHeight:0];
            
//            if (self.activityButtomView) {
//
//                [self.activityButtomView removeFromSuperview];
//            }
//            self.activityButtomView = bottomView;
            
        }
        
    }
}

- (void)_willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self _willShowBottomHeight:toFrame.size.height];
        
//        if (self.activityButtomView) {
//            [self.activityButtomView removeFromSuperview];
//        }
//        self.activityButtomView = nil;
        
        
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self _willShowBottomHeight:0];
        
    }
    else{
        [self _willShowBottomHeight:toFrame.size.height];
        
    }
    
}
#pragma mark - DXFaceDelegate

- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete
{
    NSString *chatText = self.inputTextView.text;
    
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTextView.attributedText];
    
    if (!isDelete && str.length > 0) {
        if (self.version >= 7.0) {
//            NSRange range = [self.inputTextView selectedRange];
//            [attr insertAttributedString:[[NSMutableAttributedString alloc ] initWithString:str attributes:nil ] atIndex:range.location + range.length];
            self.inputTextView.text = @"";
            self.inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
        } else {
            self.inputTextView.text = @"";
            self.inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,str];
        }
    }
    else {
        if (self.version >= 7.0) {
            if (chatText.length > 0) {
                [self deleteEmoticon];
//                NSInteger length = 1;
//                if (chatText.length >= 2) {
//                    NSString *subStr = [chatText substringFromIndex:chatText.length-2];
//                    if ([GSEmotionEscape stringContainsEmoji:subStr]) {
//                        length = 2;
//                    }
//                }
//                self.inputTextView.attributedText = [self backspaceText:attr length:length];
//                [self.inputTextView deleteBackward];

            }
        } else {
            if (chatText.length >= 2)
            {
                NSString *subStr = [chatText substringFromIndex:chatText.length-2];
                if ([(GSFaceView *)self.faceView stringIsFace:subStr]) {
                    self.inputTextView.text = [chatText substringToIndex:chatText.length-2];
                    [self textViewDidChange:self.inputTextView];
                    return;
                }
            }
            
            if (chatText.length > 0) {
                self.inputTextView.text = [chatText substringToIndex:chatText.length-1];
            }
        }
    }
    
    [self textViewDidChange:self.inputTextView];
}

/*!
 @method
 @brief 删除文本光标前长度为length的字符串
 @discussion
 @param attr   待修改的富文本
 @param length 字符串长度
 @result   修改后的富文本
 */
-(NSMutableAttributedString*)backspaceText:(NSMutableAttributedString*) attr length:(NSInteger)length
{
    NSRange range = [self.inputTextView selectedRange];
    if (range.location == 0) {
        return attr;
    }
    [attr deleteCharactersInRange:NSMakeRange(range.location - length, length)];
    return attr;
}

- (void)sendFace
{
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            
            if (![_inputTextView.text isEqualToString:@""]) {
                
                //转义回来
//                NSMutableString *attStr = [[NSMutableString alloc] initWithString:self.inputTextView.attributedText.string];
//                NSString *result = [[GSEmotionEscape sharedInstance] htmlFromEmotionText:self.inputTextView.text];

                
//                [_inputTextView.attributedText enumerateAttribute:NSAttachmentAttributeName
//                                                          inRange:NSMakeRange(0, self.inputTextView.attributedText.length)
//                                                          options:NSAttributedStringEnumerationReverse
//                                                       usingBlock:^(id value, NSRange range, BOOL *stop)
//                 {
//                     if (value) {
//                         EMTextAttachment* attachment = (EMTextAttachment*)value;
//                         NSString *str = [NSString stringWithFormat:@"%@",attachment.imageName];
//                         [attStr replaceCharactersInRange:range withString:str];
//                     }
//                 }];
                [self.delegate didSendText:chatText];
                self.inputTextView.text = @"";
                [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];;
            }
        }
    }
}

- (void)sendFaceWithEmotion:(GSEmotion *)emotion
{
    if (emotion) {
        if ([self.delegate respondsToSelector:@selector(didSendText:withExt:)]) {
            [self.delegate didSendText:emotion.emotionTitle withExt:@{GENSEE_EMOTION_DEFAULT_EXT:emotion}];
            [self _willShowInputTextViewToHeight:[self _getTextViewContentH:self.inputTextView]];;
        }
    }
}


#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    _delegate = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - publick

- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    for (GSChatToolbarItem *item in self.rightItems) {
        item.button.selected = NO;
    }
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut animations:^{
        [self _willShowBottomView:nil];
    } completion:^(BOOL finished) {
        if (self.activityButtomView) {
        
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }];
    
    
    
    
    
    return result;
}

- (void)willShowBottomView:(UIView *)bottomView
{
    [self _willShowBottomView:bottomView];
}

@end



