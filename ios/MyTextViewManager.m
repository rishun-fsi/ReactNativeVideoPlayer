//
//  MyTextViewManager.m
//  ReactNativeVideoPlayer
//
//  Created by lisyunn on 2021/08/29.
//

#import "NativeVideoViewManager.h"

@implementation NativeVideoViewManager

RCT_EXPORT_MODULE(MyTextView)

- (UIView *)view
{
  
//  // デフォルトの通知センターを取得する
//  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//
//  // 通知センターに通知要求を登録する
//  // この例だと、通知センターに"Tuchi"という名前の通知がされた時に、
//  // hogeメソッドを呼び出すという通知要求の登録を行っている。
//  [nc addObserver:self selector:@selector(hoge) name:@"Tuchi" object:nil];
//

  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  return [[NativeView alloc] initWithFrame:CGRectMake(0, 0, width, width * 9 / 16)];
  
}

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)


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
