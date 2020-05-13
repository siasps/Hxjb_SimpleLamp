//
//  HMEditTagsView.m
//  Huaxiajiabo
//
//  Created by Huamo on 2018/1/22.
//  Copyright © 2018年 huamo. All rights reserved.
//

#import "HMEditTagsView.h"

#define HMTextFiled_deleteBackward_notification @"HMTextFiled_deleteBackward_notification"


@interface HMTagButton :UIButton
@property (nonatomic, strong) UIColor* colorBg;
@property (nonatomic, strong) UIColor* colorText;
@end

@implementation HMTagButton
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    
    [self setNeedsDisplay];
}

@end



@interface HMTagTextField : UITextField

@end
@implementation HMTagTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 6 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 6 , 0 );
}



- (void)deleteBackward{
    
    if (!self.hasText) {
        [[NSNotificationCenter defaultCenter]postNotificationName:HMTextFiled_deleteBackward_notification object:nil];
    }
    
    [super deleteBackward];
}

@end



@interface HMEditTagsView()<UITextFieldDelegate>{
    NSInteger _editingTagIndex;
    NSInteger _willDeleteTagIndex; //准备回退删除
    BOOL handleDeleteTag;          //手动删除tag
}

@property (nonatomic, strong) UIScrollView* svContainer;

@property (nonatomic, strong) NSMutableArray *tagButtons;//array of alll tag button
@property (nonatomic, strong) NSMutableArray *tagStrings;//check whether tag is duplicated
@property (nonatomic, strong) NSMutableArray *tagStringsSelected;

@property (nonatomic) UITapGestureRecognizer *gestureRecognizer;

@end



@implementation HMEditTagsView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)commonInit{
    
    _tagWidht = 80;
    _tagHeight = 20;
    _tagPaddingSize = CGSizeMake(3, 5);
    _textPaddingSize = CGSizeMake(0, 3);
    _fontTag = [UIFont systemFontOfSize:12];
    _fontInput = [UIFont systemFontOfSize:12];
    _colorTag = TextColor_blue;
    _colorTagBg = [UIColor clearColor];
    
    _colorInput = TextColor_1;
    _colorInputPlaceholder = TextColor_3;
    _colorInputBg = [UIColor clearColor];
    _colorInputBord = [UIColor clearColor];
    _viewMaxHeight = 6+(20+6)*3;
    
    _willDeleteTagIndex = -1;
    handleDeleteTag = NO;
    
    self.backgroundColor = [UIColor whiteColor];
    
    _tagButtons=[NSMutableArray new];
    _tagStrings=[NSMutableArray new];
    _tagStringsSelected=[NSMutableArray new];
    
    {
        UIScrollView* sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        sv.contentSize=sv.frame.size;
        sv.contentSize=CGSizeMake(sv.frame.size.width, 600);
        sv.indicatorStyle=UIScrollViewIndicatorStyleDefault;
        sv.backgroundColor = self.backgroundColor;
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        [self addSubview:sv];
        _svContainer=sv;
    }
    {
        UITextField* tf = [[HMTagTextField alloc] initWithFrame:CGRectMake(0, 0, _svContainer.width-_tagPaddingSize.width*2, _tagHeight)];
        tf.autocorrectionType = UITextAutocorrectionTypeNo;
        [tf addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
        tf.delegate = self;
        tf.placeholder=@"添加标签";
        
        tf.returnKeyType = UIReturnKeyDone;
        [_svContainer addSubview:tf];
        _tfInput=tf;
        
        _tfInput.hidden = NO;
        
        _tfInput.backgroundColor=_colorInputBg;
        _tfInput.textColor=_colorInput;
        _tfInput.font=_fontInput;
        [_tfInput setValue:_colorInputPlaceholder forKeyPath:@"_placeholderLabel.textColor"];
        
        _tfInput.layer.cornerRadius = _tfInput.frame.size.height * 0.5f;
        _tfInput.layer.borderColor=_colorInputBord.CGColor;
        _tfInput.layer.borderWidth=1;
    }
    {
        _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _gestureRecognizer.numberOfTapsRequired=1;
        [self addGestureRecognizer:_gestureRecognizer];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteForwordString:) name:HMTextFiled_deleteBackward_notification object:nil];
}


#pragma mark - tags ui

-(NSMutableArray *)tagStrings{
    return _tagStrings;
}


-(void)layoutTagviews{
    float oldContentHeight=_svContainer.contentSize.height;
    float offsetX=_tagPaddingSize.width,offsetY=_tagPaddingSize.height;
    
    for (int i=0; i<_tagButtons.count; i++) {
        HMTagButton* tagButton=_tagButtons[i];
        CGRect frame = tagButton.frame;
        
        if (tagButton.frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
            NIF_TRACE(@"!!!  tagButton width tooooooooo large");
        }else{
            if ((offsetX+tagButton.frame.size.width+_tagPaddingSize.width)
                <=_svContainer.contentSize.width) {
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=tagButton.frame.size.width+_tagPaddingSize.width;
            }else{
                offsetX=_tagPaddingSize.width;
                offsetY+=_tagHeight+_tagPaddingSize.height;
                
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=tagButton.frame.size.width+_tagPaddingSize.width;
            }
            tagButton.frame=frame;
        }
    }
    //input view
    
    CGRect tfFrame=_tfInput.frame;
    tfFrame.size.width = [_tfInput.text sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tfInput.layer.cornerRadius * 2.0f)+ _tagHeight + _textPaddingSize.width*2;
    tfFrame.size.width=MAX(tfFrame.size.width, _tagWidht);
    //_tfInput.frame=tfFrame;
    
    if (tfFrame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
        NIF_TRACE(@"!!!  _tfInput width tooooooooo large");
        
    }else{
        
        if ((offsetX+tfFrame.size.width+_tagPaddingSize.width)
            <=_svContainer.contentSize.width) {
            tfFrame.origin.x=offsetX;
            tfFrame.origin.y=offsetY;
            offsetX+= tfFrame.size.width+_tagPaddingSize.width;
        }else{
            offsetX=_tagPaddingSize.width;
            offsetY+=_tagHeight+_tagPaddingSize.height;
            
            tfFrame.origin.x=offsetX;
            tfFrame.origin.y=offsetY;
            offsetX+= tfFrame.size.width+_tagPaddingSize.width;
        }
//        if (offsetX > 0) {
//            tfFrame.size.width = _svContainer.size.width - offsetX - _tagPaddingSize.width*2;
//        }
        _tfInput.frame=tfFrame;
        
    }
    
    
    _svContainer.contentSize=CGSizeMake(_svContainer.contentSize.width, offsetY+_tagHeight+_tagPaddingSize.height);
    {
        CGRect frame=_svContainer.frame;
        frame.size.height=_svContainer.contentSize.height;
        frame.size.height=MIN(frame.size.height, _viewMaxHeight);
        _svContainer.frame=frame;
    }
    {
        CGRect frame=self.frame;
        frame.size.height=_svContainer.frame.size.height;
        self.frame=frame;
    }
    if (_delegate) {
        [_delegate heightDidChangedTagView:self];
    }
    if (oldContentHeight != _svContainer.contentSize.height) {
        CGPoint bottomOffset = CGPointMake(0, _svContainer.contentSize.height - _svContainer.bounds.size.height);
        [_svContainer setContentOffset:bottomOffset animated:YES];
    }
    
    if (!handleDeleteTag) {
        _willDeleteTagIndex = -1;
        [_tfInput becomeFirstResponder];
    }
    handleDeleteTag = NO;
    
    /*文字输入过长时，左边部分文字不可见，加下面这句代码修改bug*/
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_tfInput markedTextRange];
        if (!selectedRange) {
            [self performSelector:@selector(ddddddd) withObject:nil afterDelay:0.1];
        }
    }
}

- (void)ddddddd{
    _tfInput.text = _tfInput.text;
}

- (HMTagButton *)tagButtonWithTag:(NSString *)tag
{
    HMTagButton *tagBtn = [[HMTagButton alloc] init];
    tagBtn.colorBg=_colorTagBg;
    tagBtn.colorText=_colorTag;
    //tagBtn.selected=YES;
    [tagBtn.titleLabel setFont:_fontTag];
    [tagBtn addTarget:self action:@selector(handlerTagButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:tag forState:UIControlStateNormal];
    
    CGRect btnFrame;
    btnFrame.size.height = _tagHeight;
    tagBtn.layer.cornerRadius = btnFrame.size.height * 0.5f;
    tagBtn.layer.masksToBounds = YES;
    
    btnFrame.size.width = [tagBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_fontTag}].width + (tagBtn.layer.cornerRadius * 2.0f) + _textPaddingSize.width*2;
    tagBtn.frame=btnFrame;
    
    [tagBtn setBackgroundColor:_colorTagBg forState:UIControlStateNormal];
    [tagBtn setTitleColor:_colorTag forState:UIControlStateNormal];
    [tagBtn setBackgroundColor:_colorTag forState:UIControlStateSelected];
    [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    return tagBtn;
}

- (void)handlerTagButtonEvent:(HMTagButton*)sender{
    
}


#pragma mark action

- (void)addTags:(NSArray *)tags{
    for (NSString *tag in tags)
    {
        [self addTagToLast:tag];
    }
    [self layoutTagviews];
}

- (void)addTags:(NSArray *)tags selectedTags:(NSArray*)selectedTags{
    [self addTags:tags];
    self.tagStringsSelected=[NSMutableArray arrayWithArray:selectedTags];
}

- (void)addTagToLast:(NSString *)tag{
//    NSArray *result = [_tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
//    if (result.count == 0)
//    {
//        [_tagStrings addObject:tag];
//
//        HMTagButton* tagButton=[self tagButtonWithTag:tag];
//        [tagButton addTarget:self action:@selector(handlerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_svContainer addSubview:tagButton];
//        [_tagButtons addObject:tagButton];
//
//
//    }
    
    
    //不需要去重
    [_tagStrings addObject:tag];
    
    HMTagButton* tagButton=[self tagButtonWithTag:tag];
    [tagButton addTarget:self action:@selector(handlerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_svContainer addSubview:tagButton];
    [_tagButtons addObject:tagButton];
    
    
    [self layoutTagviews];
}

- (void)removeTags:(NSArray *)tags{
    for (NSString *tag in tags)
    {
        [self removeTag:tag];
    }
    [self layoutTagviews];
}
- (void)removeTag:(NSString *)tag{
//    NSArray *result = [_tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
//    if (result)
//    {
//        NSInteger index=[_tagStrings indexOfObject:tag];
//        [_tagStrings removeObjectAtIndex:index];
//        [_tagButtons[index] removeFromSuperview];
//        [_tagButtons removeObjectAtIndex:index];
//    }
//    [self layoutTagviews];
    
    
    NSInteger index=[_tagStrings indexOfObject:tag];
    [_tagStrings removeObjectAtIndex:index];
    [_tagButtons[index] removeFromSuperview];
    [_tagButtons removeObjectAtIndex:index];
    
    [self layoutTagviews];
}


-(void)handlerButtonAction:(HMTagButton*)tagButton{
    handleDeleteTag = YES;
    
    for (HMTagButton *button in _tagButtons) {
        button.selected = NO;
    }
    tagButton.selected = YES;
    
    [self becomeFirstResponder];
    _editingTagIndex=[_tagButtons indexOfObject:tagButton];
    CGRect buttonFrame=tagButton.frame;
    buttonFrame.size.height-=5;
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteItemClicked:)];
    
    NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);
    [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
    [menuController setTargetRect:buttonFrame inView:_svContainer];
    [menuController setMenuVisible:YES animated:YES];
    
}


#pragma mark UITextFieldDelegate

- (void)deleteForwordString:(NSNotification *)notification{
    if (_tagStrings.count <= 0) {
        return;
    }
    
    if (_willDeleteTagIndex == -1) {
        _willDeleteTagIndex = _tagStrings.count-1;
        
        for (HMTagButton *button in _tagButtons) {
            button.selected = NO;
        }
        HMTagButton *button = (HMTagButton *)[_tagButtons objectAtIndex:_willDeleteTagIndex];
        button.selected = YES;
        
        return;
    }
    
    if (_willDeleteTagIndex == _tagStrings.count-1) {
        //[self removeTag:_tagStrings[_willDeleteTagIndex]];
        
        [_tagStrings removeObjectAtIndex:_willDeleteTagIndex];
        [_tagButtons[_willDeleteTagIndex] removeFromSuperview];
        [_tagButtons removeObjectAtIndex:_willDeleteTagIndex];
        
        [self layoutTagviews];
    }
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (!textField.text
        || [textField.text isEqualToString:@""]) {
        return NO;
    }
    NSString *fieldText = [NSString stringWithFormat:@"#%@", textField.text];
    
    [self addTagToLast:fieldText];
    textField.text=nil;
    [self layoutTagviews];
    return NO;
}

-(void)textFieldDidChange:(UITextField*)textField{
    CGRect frame=_tfInput.frame;
    frame.size.width = [textField.text sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tfInput.layer.cornerRadius * 2.0f)+ _tagHeight + _textPaddingSize.width*2;
    frame.size.width=MAX(frame.size.width, _tagWidht);
    
    if (frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
        NIF_TRACE(@"!!!  _tfInput width tooooooooo large");
        
        NSInteger tempIndex = 0;
        for (NSInteger i=1; i<textField.text.length; i++) {
            NSString *tempStr = [textField.text substringToIndex:textField.text.length-i];
            
            CGFloat width = [tempStr sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tfInput.layer.cornerRadius * 2.0f)+ _tagHeight + _textPaddingSize.width*2;
            if (width+_tagPaddingSize.width*2 <= _svContainer.contentSize.width) {
                tempIndex = i;
                break;
            }
        }
        
        textField.text = [textField.text substringToIndex:textField.text.length-tempIndex];
        
        return;
    }
    
    
    [self layoutTagviews];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* sting2= [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    CGRect frame=_tfInput.frame;
    frame.size.width = [sting2 sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tfInput.layer.cornerRadius * 2.0f)+ _tagHeight + _textPaddingSize.width*2;
    frame.size.width=MAX(frame.size.width, _tagWidht);
    
    if (frame.size.width+_tagPaddingSize.width*2>_svContainer.contentSize.width) {
        NIF_TRACE(@"!!!  _tfInput width tooooooooo large");
        return NO;
    }
    else{
        return YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    for (HMTagButton *button in _tagButtons) {
        button.selected = NO;
    }
    _willDeleteTagIndex = -1;
    
    
    if ([_delegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate performSelector:@selector(textFieldDidBeginEditing:) withObject:textField];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self layoutTagviews];
    if ([_delegate conformsToProtocol:@protocol(UITextFieldDelegate)]
        && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_delegate performSelector:@selector(textFieldDidEndEditing:) withObject:textField];
    }
}
#pragma mark UIMenuController

- (void) deleteItemClicked:(id) sender {
    [self removeTag:_tagStrings[_editingTagIndex]];
}
- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(deleteItemClicked:) /*|| selector == @selector(copy:)*/ /**<enable that if you want the copy item */) {
        return YES;
    }
    return NO;
}
- (BOOL) canBecomeFirstResponder {
    return YES;
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
#pragma mark getter & setter
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _svContainer.backgroundColor=backgroundColor;
}

-(void)setColorTagBg:(UIColor *)colorTagBg{
    _colorTagBg=colorTagBg;
    for (HMTagButton* button in _tagButtons) {
        button.colorBg=colorTagBg;
    }
}

-(void)setColorTag:(UIColor *)colorTag{
    _colorTag=colorTag;
    for (HMTagButton* button in _tagButtons) {
        button.colorText=colorTag;
    }
}




@end
