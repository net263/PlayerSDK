//
//  GSChatModel.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/14.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSVodChatModel.h"
#import "GSTextAttachment.h"

#define WIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) - 20)

@implementation GSVodChatModel

- (instancetype)initWithModel:(VodChatInfo*)obj{
    if (self = [super init]) {
        
        if (obj) {
            self.info = obj.senderName;
            self.infoHeight = [GSBaseModel heightWithString:self.info LabelFont:[UIFont boldSystemFontOfSize:18.f] withLabelWidth:WIDTH];
            
            NSAttributedString *attribute = [[GSEmotionEscape sharedInstance] attributeStringFromHtml:obj.text textFont:[UIFont fontWithName:@"Heiti SC" size:14.f] imageType:@"png"];
            
            self.message = attribute;

            CGRect rect = [self.message boundingRectWithSize:CGSizeMake(WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
            self.messageHeight = rect.size.height;
            self.msgID = obj.chatid;
            self.chatMessage = obj;
            
//            NSDate *currentDate = [NSDate date:obj.timestamp];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"HH:mm:ss"];
//            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            self.timeStr = [self timeFormat:obj.timestamp*1000];
        }
       
        self.totalHeight = self.infoHeight + self.messageHeight;
        
    }
    return self;
}

- (NSString*)timeFormat:(int)time {
    int t = time;
    int hours = t/1000/60/60;
    int minutes = (t/1000/60)%60;
    int seconds = (t/1000)%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    
}



@end
