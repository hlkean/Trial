//
//  ViewController.m
//  Trial
//
//  Created by Henry Kean on 4/27/15.
//  Copyright (c) 2015 Henry Kean. All rights reserved.
//
#import "Config.h"
#import "ViewController.h"
#import <Spotify/SPTDiskCache.h>

@interface ViewController () <SPTAudioStreamingDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *coverView2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) SPTAudioStreamingController *player;

@end


@implementation ViewController

   NSInteger imageIndex = 7;
- (IBAction)swipePic:(UIGestureRecognizer *)sender {
 
    NSArray *images=[[NSArray alloc] initWithObjects:
                     @"Lobster.jpg",
                     @"Beer.jpg",
                     @"Nam.jpg",
                     @"Viking.jpg",
                     @"Tiger.jpg",
                     @"Masks.jpg",
                     @"FieldHockey.jpg",
                     @"Fam.jpg",nil];
    
    UISwipeGestureRecognizerDirection direction =
    [(UISwipeGestureRecognizer *) sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft: imageIndex++;
            break;
        case UISwipeGestureRecognizerDirectionRight: imageIndex--;
            break;
        default:
            break;
    }
    imageIndex = (imageIndex < 0) ? ([images count] -1):
    imageIndex % [images count];
    _Pic.image = [UIImage imageNamed:[images objectAtIndex:imageIndex]];

    
}




- (IBAction)TouchMeh:(UIGestureRecognizer *)sender {

    if ([_EarArea isHidden]) {
        [_EarArea setHidden:NO];
        [_Pic setFrame:CGRectMake(0, 0, self.view.frame.size.width, 914)];
    } else {
        [_EarArea setHidden:YES];
        [_Pic setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    
    
    NSLog(@"touched");
}




    








- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"Nothing Playing";
    self.albumLabel.text = @"";
    self.artistLabel.text = @"";
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Actions

-(IBAction)rewind:(id)sender {
    [self.player skipPrevious:nil];
}

-(IBAction)playPause:(id)sender {
    [self.player setIsPlaying:!self.player.isPlaying callback:nil];
}

-(IBAction)fastForward:(id)sender {
    [self.player skipNext:nil];
}

- (IBAction)logoutClicked:(id)sender {
    SPTAuth *auth = [SPTAuth defaultInstance];
    if (self.player) {
        [self.player logout:^(NSError *error) {
            auth.session = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Logic



-(void)updateUI {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (self.player.currentTrackURI == nil) {
        self.coverView.image = nil;
        self.coverView2.image = nil;
        return;
    }
    
    [self.spinner startAnimating];
    
    [SPTTrack trackWithURI:self.player.currentTrackURI
                   session:auth.session
                  callback:^(NSError *error, SPTTrack *track) {
                      
                      self.titleLabel.text = track.name;
                      self.albumLabel.text = track.album.name;
                      
                      SPTPartialArtist *artist = [track.artists objectAtIndex:0];
                      self.artistLabel.text = artist.name;
                      
                      NSURL *imageURL = track.album.largestCover.imageURL;
                      if (imageURL == nil) {
                          NSLog(@"Album %@ doesn't have any images!", track.album);
                          self.coverView.image = nil;
                          self.coverView2.image = nil;
                          return;
                      }
                      
                      // Pop over to a background queue to load the image over the network.
                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                          NSError *error = nil;
                          UIImage *image = nil;
                          NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:0 error:&error];
                          
                          if (imageData != nil) {
                              image = [UIImage imageWithData:imageData];
                          }
                          
                          
                          // …and back to the main queue to display the image.
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self.spinner stopAnimating];
                              self.coverView.image = image;
                              if (image == nil) {
                                  NSLog(@"Couldn't load cover image with error: %@", error);
                                  return;
                              }
                          });
                          

                      });
                      
                  }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self handleNewSession];
}

-(void)handleNewSession {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (self.player == nil) {
        self.player = [[SPTAudioStreamingController alloc] initWithClientId:auth.clientID];
        self.player.playbackDelegate = self;
        self.player.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
    }
    
    [self.player loginWithSession:auth.session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
        [self updateUI];
        
        NSURLRequest *playlistReq = [SPTPlaylistSnapshot createRequestForPlaylistWithURI:[NSURL URLWithString:@"spotify:user:1239735521:playlist:36T7jEOVKw1bWxNeNhYpM1"]
                                                                             accessToken:auth.session.accessToken
                                                                                   error:nil];
        
        [[SPTRequest sharedHandler] performRequest:playlistReq callback:^(NSError *error, NSURLResponse *response, NSData *data) {
            if (error != nil) {
                NSLog(@"*** Failed to get playlist %@", error);
                return;
            }
            
            SPTPlaylistSnapshot *playlistSnapshot = [SPTPlaylistSnapshot playlistSnapshotFromData:data withResponse:response error:nil];
            
            [self.player playURIs:playlistSnapshot.firstTrackPage.items fromIndex:0 callback:nil];
        }];
    }];
}

#pragma mark - Track Player Delegates

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message from Spotify"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didFailToPlayTrack:(NSURL *)trackUri {
    NSLog(@"failed to play track: %@", trackUri);
}

- (void) audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeToTrack:(NSDictionary *)trackMetadata {
    NSLog(@"track changed = %@", [trackMetadata valueForKey:SPTAudioStreamingMetadataTrackURI]);
    [self updateUI];
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying {
    NSLog(@"is playing = %d", isPlaying);
}





@end
