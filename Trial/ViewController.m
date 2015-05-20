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
#import "InfoViewController.h"
@interface ViewController () <SPTAudioStreamingDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *coverView2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (atomic, readwrite) ViewController *toonWindow;
@property (atomic, readwrite) InfoViewController *infoWindow;

//image slide effect
@property (nonatomic, strong) NSArray *pageImageNames;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;


@end


@implementation ViewController


@synthesize scrollView = _scrollView;


@synthesize pageImageNames = _pageImages;
@synthesize pageViews = _pageViews;


//   NSInteger imageIndex = 7;
//- (IBAction)swipePic:(UIGestureRecognizer *)sender {
// 
//    NSArray *images=[[NSArray alloc] initWithObjects:
//                     @"Lobster.jpg",
//                     @"Beer.jpg",
//                     @"Nam.jpg",
//                     @"Viking.jpg",
//                     @"Tiger.jpg",
//                     @"Masks.jpg",
//                     @"FieldHockey.jpg",
//                     @"Fam.jpg",nil];
//    
//    UISwipeGestureRecognizerDirection direction =
//    [(UISwipeGestureRecognizer *) sender direction];
//    
//    switch (direction) {
//        case UISwipeGestureRecognizerDirectionLeft: imageIndex++;
//            break;
//        case UISwipeGestureRecognizerDirectionRight: imageIndex--;
//            break;
//        default:
//            break;
//    }
//    imageIndex = (imageIndex < 0) ? ([images count] -1):
//    imageIndex % [images count];
//    _Pic.image = [UIImage imageNamed:[images objectAtIndex:imageIndex]];
//
//    
//}
//



- (IBAction)touchMeh:(UIGestureRecognizer *)sender {


    if ([_EarArea isHidden]) {
        [_EarArea setHidden:NO];
       
    } else {
        [_EarArea setHidden:YES];
           }
    
    
    
    NSLog(@"touched");
}




    

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImageNames.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        NSString* imageName = [self.pageImageNames objectAtIndex:page];
        NSString* imagePath = [ [ NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        UIImageView *newPageView = [ [UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:imagePath]];

        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}



- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImageNames.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}
- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 7;
    NSInteger lastPage = page + 7;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
    // Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
    // Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImageNames.count; i++) {
        [self purgePage:i];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"Nothing Playing";
    self.albumLabel.text = @"";
    self.artistLabel.text = @"";
  
    //ImageSlide
    // 1
    
    
    self.pageImageNames = [NSArray arrayWithObjects:
                           @"Lobster",
                           @"Beer",
                           @"Nam",
                          @"Viking",
                            @"Tiger",
                           @"Masks",
                           @"FieldHockey",
                          @"Fam",
                       nil];
    
    NSInteger pageCount = self.pageImageNames.count;
    
    
    // 3
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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



- (void)closeToons {
    
    [self.player stop:nil];
//        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *toonWindow = [storybord   instantiateViewControllerWithIdentifier:@"infoPage"] ;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.toonWindow.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.toonWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.definesPresentationContext = YES;
    
                
}


- (IBAction)closeClicked:(id)sender {
    [self closeToons];
}

//- (IBAction)logoutClicked:(id)sender {
//    SPTAuth *auth = [SPTAuth defaultInstance];
//    if (self.player) {
//        [self.player logout:^(NSError *error) {
//            auth.session = nil;
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

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
                      
//                      NSURL *imageURL = track.album.largestCover.imageURL;
//                      if (imageURL == nil) {
//                          NSLog(@"Album %@ doesn't have any images!", track.album);
//                          self.coverView.image = nil;
//                          self.coverView2.image = nil;
                          return;
                      }
                      
                      // Pop over to a background queue to load the image over the network.
//                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                          NSError *error = nil;
//                          UIImage *image = nil;
//                          NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:0 error:&error];
//                          
//                          if (imageData != nil) {
//                              image = [UIImage imageWithData:imageData];
//                          }
     
                          
                          // …and back to the main queue to display the image.
//                          dispatch_async(dispatch_get_main_queue(), ^{
//                              [self.spinner stopAnimating];
//                              self.coverView.image = image;
//                              if (image == nil) {
//                                  NSLog(@"Couldn't load cover image with error: %@", error);
//                                  return;
//                              }
//                          });
//                          
//
//                      });
//                      
//                  }];
     ];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self handleNewSession];
    
    // 4
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImageNames.count, pagesScrollViewSize.height);
    
    // 5
    [self loadVisiblePages];
    
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
