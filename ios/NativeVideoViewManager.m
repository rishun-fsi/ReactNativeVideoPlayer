//
//  NativeVideoViewManager.m
//  ReactNativeVideoPlayer
//
//  Created by lisyunn on 2021/08/29.
//

#import "NativeVideoViewManager.h"

@implementation NativeVideoViewManager

RCT_EXPORT_MODULE(NativeVideoView)

- (UIView *)view
{
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  return [[NativeView alloc] initWithFrame:CGRectMake(0, 0, width, width * 9 / 16)];
}

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock)


RCT_CUSTOM_VIEW_PROPERTY(value, NSString, NativeView) {
  NSString *urlStr = json;
  //view.backgroundColor = [UIColor redColor];
  //view.text = modeStr;
  //  UITextView *newView = [[UITextView alloc] initWithFrame:self.view.bounds];
  //
  //  newView.text = modeStr;
  //  [view addSubview:newView];
  

  [view setVideoView:urlStr nativeview:view];
  
}

@end
