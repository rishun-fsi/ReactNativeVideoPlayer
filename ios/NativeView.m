//
//  NativeView.m
//  ReactNativeVideoPlayer
//
//  Created by lisyunn on 2021/09/04.
//

#import "NativeView.h"

@implementation NativeView

AVPlayerLayer *playerLayer;
AVPlayer     *player;
AVPlayerItem *playerItem;
UIActivityIndicatorView *indicator;

- (void) setVideoView:(NSString *)urlStr nativeview: (NativeView *) view {
  
  
//    // デフォルトの通知センターを取得する
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//  
//    // 通知センターに通知要求を登録する
//    // この例だと、通知センターに"Tuchi"という名前の通知がされた時に、
//    // hogeメソッドを呼び出すという通知要求の登録を行っている。
//    [nc addObserver:self selector:@selector(hoge) name:@"Tuchi" object:nil];
  

  
  AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:urlStr]];
  playerItem = [[AVPlayerItem alloc]initWithAsset:asset];
  player = [AVPlayer playerWithPlayerItem:playerItem];
  playerLayer = [AVPlayerLayer playerLayerWithPlayer: player];
  playerLayer.frame = view.layer.bounds;
  //UIView *newView = [[UIView alloc] initWithFrame:self.view.bounds];
  [view.layer addSublayer:playerLayer];
  //[view addSubview:newView];

  [player play];
  
  [playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
  
  [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
  
  // インスタンスを作る
  indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
      
  // 画面の中央に表示するようにframeを変更する
  float w = indicator.frame.size.width;
  float h = indicator.frame.size.height;
  float x = self.frame.size.width/2 - w/2;
  float y = self.frame.size.height/2 - h/2;
  indicator.frame = CGRectMake(x, y, w, h);
          
  // クルクルと回し始める
  [indicator startAnimating];
      
  // サブビューに追加する
  [self addSubview:indicator];
  

}


-(void)observeValueForKeyPath:(NSString*)path ofObject:(id)object change:(NSDictionary*)change context:(void*) context {
  if([playerLayer isReadyForDisplay]){
    [indicator stopAnimating];
    indicator.hidesWhenStopped = YES;
    if (self.onChange) {
      NSLog(@"Duration: %f", CMTimeGetSeconds(player.currentItem.duration));
      self.onChange(@{
        //@"message": @"ios mymessage"
        @"duration": @(CMTimeGetSeconds(player.currentItem.duration))
                    });
    }
    return;
  }
  if (playerItem.status == AVPlayerItemStatusFailed) {
    if(self.onError) {
      self.onError(@{
        @"error": @"Player item failed."
                   });
    }
    return;
  }
}

//- (UIActivityIndicatorView *)showIndicator
//{
////    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
//    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    view.center = CGPointMake(60, 30);
//    //[alertController.view addSubview:view];
//    [view startAnimating];
//  return view;
//}


+ (NSNumber *)getPosition
{
  // Hogeクラス側から渡されてくる文字列をラベルに表示します。
  //NSLog(@"Time: %f", CMTimeGetSeconds(player.currentTime));
  return @(CMTimeGetSeconds(player.currentTime));
}

+ (void) sendMessage:(NSString *)message
{
  if ([message isEqualToString: @"play"]) {
    [player play];
  } else if ([message isEqualToString: @"pause"]) {
    [player pause];
  }
  else if ([message isEqualToString: @"fast_backward"]) {
    Float64 position = CMTimeGetSeconds(player.currentTime);
    Float64 seekPos = position - 10 < 0 ? 0 : position - 10;
    [player seekToTime: CMTimeMakeWithSeconds(seekPos, NSEC_PER_SEC)];
    
  } else if ([message isEqualToString: @"fast_forward"]) {
    Float64 position = CMTimeGetSeconds(player.currentTime);
    Float64 duration = CMTimeGetSeconds(player.currentItem.duration);
    Float64 seekPos = position + 10 > duration ? duration : position + 10;
    [player seekToTime: CMTimeMakeWithSeconds(seekPos, NSEC_PER_SEC)];
  }
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)removeFromSuperview {
  [playerItem removeObserver:self forKeyPath:@"status" context:NULL];
  [playerLayer removeObserver:self forKeyPath:@"readyForDisplay" context:NULL];
  [player pause];
  //[player replaceCurrentItemWithPlayerItem:NULL];
  [playerLayer removeFromSuperlayer];
  [indicator removeFromSuperview];
  indicator = NULL;
  player = NULL;
  playerLayer = NULL;
}

@end
