//
//  LELocalNotification.m
//  ticket
//
//  Created by Larry Emerson on 14-2-20.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import "LELocalNotification.h"



#define MessageEnterTime 0.3
#define MessagePauseTime    1.2

@implementation LELocalNotification{
    UILabel *curText;
    BOOL isShowing;
    CGRect startRect;
    CGRect endRect;
    
    CATransition *transition;
    
    UIImageView *BGView;
    int height;
//    LEUIFramework *globalVar;
    BOOL isEverUsed;
    int MessageBoardWidth;
    int space;
    int MessageFontSize;
    int MessageSpace;
    NSTimer *extraCheck;
}
- (id)initWithFrame:(CGRect)frame{
//    globalVar=[LEUIFramework sharedInstance];
    self = [super initWithFrame:frame];
    [self setUserInteractionEnabled:NO];
    if (self) {
//        UIImage *BG=[UIImage imageNamed:@"LE_MessageBackground"];
        UIImage *BG=[LEColorGrayDark leImageStrechedFromSizeOne];
        height=40;
        space=10;
        MessageFontSize =16;
        MessageSpace = 2;
        MessageBoardWidth=LESCREEN_WIDTH-space*2;
        [self setFrame:CGRectMake(space, LESCREEN_HEIGHT+MessageFontSize*10, MessageBoardWidth, BG.size.height)];
        BGView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MessageBoardWidth, height)];
        [BGView setImage:BG];
        [BGView leSetRoundCornerWithRadius:6];
        [self addSubview:BGView];
        curText=[[UILabel alloc]initWithFrame:CGRectMake(MessageBoardWidth/2, MessageSpace, MessageBoardWidth-MessageSpace*2, height-MessageSpace*2)];
        [curText setContentMode:UIViewContentModeCenter];
        [curText setTextAlignment:NSTextAlignmentCenter];
        [curText setFont:[UIFont systemFontOfSize:MessageFontSize]];
        [curText setTextColor:LEColorWhite];
        [curText setText:@"                         "];
        [curText setNumberOfLines:0];
        [BGView addSubview:curText];
        [BGView setClipsToBounds:YES];
        startRect=self.frame;
        endRect=self.frame;
        endRect.origin.y=LESCREEN_HEIGHT-MessageSpace;
        // effect
        transition = [CATransition animation];
        [transition setDuration:MessageEnterTime];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transition setType:kCATransitionFade];
        [transition setDelegate: self];
    }
    return self;
}
-(void) leSetText:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime {
    [self.layer removeAllAnimations];
    [self leSetText:text WithEnterTime:time AndPauseTime:pauseTime ReleaseWhenFinished:NO];
}
-(void) leReleaseView{
    [BGView setImage:nil];
    [BGView removeFromSuperview];
    BGView=nil;
    [curText removeFromSuperview];
    curText=nil;
    [extraCheck invalidate];
    extraCheck=nil;
    [transition setDelegate:nil];
    transition=nil;
    [self removeFromSuperview];
}
-(void) leSetText:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRelease{
    if(!text){
        [self leReleaseView];
        return;
    }
    [extraCheck invalidate];
    extraCheck=[NSTimer scheduledTimerWithTimeInterval:time+pauseTime+0.1 target:self selector:@selector(onCheck) userInfo:nil repeats:NO];
    [self setAlpha:0];
    [self setFrame:startRect];
    CGSize sizeContent = [text leGetSizeWithFont:curText.font MaxSize:CGSizeMake(MessageBoardWidth-MessageSpace*2, LELabelMaxSize.height)] ;
    endRect.size.height=MessageSpace*2+sizeContent.height;
    endRect.origin.y=LESCREEN_HEIGHT-MessageSpace*2-sizeContent.height-LENavigationBarHeight;
    if(endRect.size.height<height){
        endRect.size.height=height;
    }
    [curText setText:text];
    [curText.layer addAnimation:transition forKey:nil];
    [curText setBackgroundColor:[UIColor clearColor]];
    if(!isEverUsed){
        isEverUsed=YES;
        [curText setFrame:CGRectMake((MessageBoardWidth-sizeContent.width)/2, endRect.size.height/2-sizeContent.height/2, sizeContent.width, sizeContent.height)];
    }
    [UIView  animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        [self setFrame:endRect];
        [BGView setFrame:CGRectMake(self.bounds.size.width/2-sizeContent.width/2-LENavigationBarHeight/2, 0, sizeContent.width+LENavigationBarHeight, endRect.size.height)];
        [curText setFrame:CGRectMake((BGView.bounds.size.width-sizeContent.width)/2, BGView.bounds.size.height/2-sizeContent.height/2, sizeContent.width, sizeContent.height)];
        [self setAlpha:1];
    } completion:^(BOOL isFinished){
        if(isFinished){
            [UIView animateWithDuration:time delay:pauseTime options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                [self setAlpha:0];
            } completion:^(BOOL done){
                if(isRelease){
                    [extraCheck invalidate];
                    [self leReleaseView];
                }
            }];
        }
    }];
}
-(void) onCheck{
    [self leReleaseView];
}

//- (id)initWithFrame:(CGRect)frame
//{
//    globalVar=[LEUIFramework sharedInstance];
//    self = [super initWithFrame:frame];
//    [self setUserInteractionEnabled:NO];
//    if (self) {
//        UIImage *BG=[[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_MessageBackground"]; 
//        height=BG.size.height;
//        space=10;
//        MessageFontSize =20;
//        MessageSpace = 2;
//        MessageBoardWidth=LESCREEN_WIDTH-space*2;
//        [self setFrame:CGRectMake(space, -MessageFontSize*10, MessageBoardWidth, BG.size.height)];
//        BGView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MessageBoardWidth, height)];
//        [BGView setImage:[BG stretchableImageWithLeftCapWidth:BG.size.width/2 topCapHeight:BG.size.height/2]];
//        [self addSubview:BGView];
//        curText=[[UILabel alloc]initWithFrame:CGRectMake(MessageBoardWidth/2, MessageSpace, MessageBoardWidth-MessageSpace*2, height-MessageSpace*2)];
//        [curText setContentMode:UIViewContentModeCenter];
//        [curText setTextAlignment:NSTextAlignmentCenter];
//        [curText setFont:[UIFont systemFontOfSize:MessageFontSize]];
//        [curText setTextColor:LEColorWhite];
//        [curText setText:@"                         "];
//        [curText setNumberOfLines:0];
//        [BGView addSubview:curText];
//        [BGView setClipsToBounds:YES];
//        startRect=self.frame;
//        endRect=self.frame;
//        endRect.origin.y=20+MessageSpace;
//        // effect
//        transition = [CATransition animation];
//        [transition setDuration:MessageEnterTime];
//        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [transition setType:kCATransitionFade];
//        [transition setDelegate: self];
//    }
//    return self;
//}
//-(void) leSetText:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime {
//    [self.layer removeAllAnimations];
//    [self leSetText:text WithEnterTime:time AndPauseTime:pauseTime ReleaseWhenFinished:NO];
//}
//-(void) leSetText:(NSString *) text WithEnterTime:(float) time AndPauseTime:(float) pauseTime ReleaseWhenFinished:(BOOL) isRelease{
//    if(!text){
//        [self removeFromSuperview];
//        return;
//    }
//    [extraCheck invalidate];
//    extraCheck=[NSTimer scheduledTimerWithTimeInterval:time+pauseTime+0.1 target:self selector:@selector(onCheck) userInfo:nil repeats:NO];
//    [self setAlpha:0];
//    [self setFrame:startRect];
//    CGSize sizeContent = [text leGetSizeWithFont:curText.font MaxSize:CGSizeMake(MessageBoardWidth-MessageSpace*2, LELabelMaxSize.height)] ;
//    endRect.size.height=MessageSpace*2+sizeContent.height;
//    if(endRect.size.height<height){
//        endRect.size.height=height;
//    }
//    [curText setText:text];
//    [curText.layer addAnimation:transition forKey:nil];
//    [curText setBackgroundColor:[UIColor clearColor]];
//    if(!isEverUsed){
//        isEverUsed=YES;
//        [curText setFrame:CGRectMake((MessageBoardWidth-sizeContent.width)/2, endRect.size.height/2-sizeContent.height/2, sizeContent.width, sizeContent.height)];
//    }
//    [UIView  animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
//        [self setFrame:endRect];
//        [BGView setFrame:CGRectMake(0, 0, endRect.size.width, endRect.size.height)];
//        [curText setFrame:CGRectMake((MessageBoardWidth-sizeContent.width)/2, endRect.size.height/2-sizeContent.height/2, sizeContent.width, sizeContent.height)];
//        [self setAlpha:1];
//    } completion:^(BOOL isFinished){
//        if(isFinished){
//            [UIView animateWithDuration:time delay:pauseTime options:UIViewAnimationOptionCurveEaseOut animations:^(void){
//                [self setAlpha:0];
//            } completion:^(BOOL done){
//                if(isRelease){
//                    [extraCheck invalidate];
//                    [self removeFromSuperview];
//                }
//            }];
//        }
//    }];
//}
//-(void) onCheck{
//    [extraCheck invalidate];
//    extraCheck=nil;
//    [self removeFromSuperview];
//}

@end
