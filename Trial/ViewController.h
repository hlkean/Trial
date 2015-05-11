//
//  ViewController.h
//  Trial
//
//  Created by Henry Kean on 4/27/15.
//  Copyright (c) 2015 Henry Kean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@interface ViewController : UIViewController<SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *Pic;

- (IBAction)swipePic:(UIGestureRecognizer *)sender;


@property (strong, nonatomic) IBOutlet UIView *EyeArea;
- (IBAction)TouchMeh:(UIGestureRecognizer *)sender;

@property (strong, nonatomic) IBOutlet UIView *EarArea;

@end

