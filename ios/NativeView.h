//
//  NativeView.h
//  ReactNativeVideoPlayer
//
//  Created by lisyunn on 2021/09/04.
//

#import <UIKit/UIKit.h>
#import "NativeVideoViewManager.h"
#import "RCTPlayControllerModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface NativeView : UIView
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) RCTDirectEventBlock onError;


- (void) setVideoView:(NSString *)urlStr nativeview: (NativeView *) view;

+ (NSNumber *)getPosition;
+ (void) sendMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
