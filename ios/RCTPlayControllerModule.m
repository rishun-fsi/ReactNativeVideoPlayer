//
//  RCTPlayControllerModule.m
//  ReactNativeVideoPlayer
//
//  Created by lisyunn on 2021/08/22.
//

// RCTPlayControllerModule.m
#import <React/RCTLog.h>
#import "RCTPlayControllerModule.h"

@implementation RCTPlayControllerModule

RCT_EXPORT_MODULE(PlayControllerModule);

RCT_EXPORT_METHOD(sendPlayControllerEvent:(NSString *)message)
{
  [NativeView sendMessage:message];
}

RCT_EXPORT_METHOD(createPlayControllerEvent:(NSString *)key value:(NSString *)valuecallback: (RCTResponseSenderBlock)callback)
{
  
  
//  // 通知を作成する
//  NSNotification *n = [NSNotification notificationWithName:@"Tuchi" object:self];
//  
//  // 通知実行！
//  [[NSNotificationCenter defaultCenter] postNotification:n];
  
  //RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
  
//  [NativeView hoge];
//
//  NSNumber *eventId = [NSNumber numberWithInt:123];
  callback(@[[NativeView getPosition]]);
  
}

//RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getName)
//{
//return [[UIDevice currentDevice] name];
//}


@end
