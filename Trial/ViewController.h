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


//@property (strong, nonatomic) IBOutlet UIImageView *Pic;
//
//- (IBAction)swipePic:(UIGestureRecognizer *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *Eyes;



@property (strong, nonatomic) IBOutlet UIView *EarArea;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)touchMeh:(UIGestureRecognizer *)sender;


@end

