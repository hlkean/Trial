//
//  Info ViewController.m
//  Trial
//
//  Created by Henry Kean on 5/18/15.
//  Copyright (c) 2015 Henry Kean. All rights reserved.
//
#import "config.h"
#import "InfoViewController.h"
#import "LoginController.h"
#import <Spotify/SPTDiskCache.h>
#import "AppDelegate.h"
@interface InfoViewController ()<SPTAudioStreamingDelegate>

@property (atomic, readwrite) LoginController *loginWindow;

@property (atomic, readwrite) InfoViewController *infoWindow;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation InfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getLists];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)getLists {
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSString *me = auth.session.canonicalUsername;
    
    NSURLRequest *playlistrequest = [SPTPlaylistList createRequestForGettingPlaylistsForUser:auth.session.canonicalUsername withAccessToken:auth.session.accessToken error:nil];
    
    [[SPTRequest sharedHandler] performRequest:playlistrequest callback:^(NSError *error, NSURLResponse *response, NSData *data) {
        if (error != nil) { NSLog(@"*** Failed to get list %@", error);
            return;
        }
        SPTPlaylistList *playlists = [SPTPlaylistList playlistListFromData:data withResponse:response error:nil];
        NSLog(@"Got %@'s playlists, first page %@", playlists, me);
        NSArray *Stuff = playlists.items;
        NSMutableArray *list1 = [[NSMutableArray alloc] init];
        for (int i=0; i < Stuff.count; i++)
        {
            
            SPTPartialPlaylist *object = [Stuff objectAtIndex:i];
            NSString *name = object.name;
            [list1 addObject:name];
            
        }
        self.listArray = list1;
        
        //        SPTPartialPlaylist *test =
        //        NSString *name = test.name;
        
        
        
        
        //        [list1 partialPlaylistFromDecodedJSON:Stuff error:nil];
        //        NSLog(@"%@", info);
        
        
        
        //        NSURLRequest *playlistrequest2 = [playlists createRequestForNextPageWithAccessToken:auth.session.accessToken error:nil];
        //        [[SPTRequest sharedHandler] performRequest:playlistrequest2 callback:^(NSError *error2, NSURLResponse *response2, NSData *data2) {
        //            if (error2 != nil) { NSLog(@"*** Failed to get list %@", error);
        //                return;
        //            }
        //            SPTPlaylistList *playlists2 = [SPTPlaylistList playlistListFromData:data2 withResponse:response2 error:nil];
        //            NSLog(@"Got %@'s playlists, second page: %@", me, playlists2);
        //
        //        }];
        //        NSURLRequest *playlistrequest3 = [playlists createRequestForNextPageWithAccessToken:auth.session.accessToken error:nil];
        //        [[SPTRequest sharedHandler] performRequest:playlistrequest3 callback:^(NSError *error3, NSURLResponse *response3, NSData *data3) {
        //            if (error3 != nil) { NSLog(@"*** Failed to get list %@", error);
        //                return;
        //            }
        //            SPTPlaylistList *playlists3 = [SPTPlaylistList playlistListFromData:data3 withResponse:response3 error:nil];
        //            NSLog(@"Got %@'s playlists, third page: %@", me, playlists3);
        //            
        //        }];
        NSLog(@"%u", _listArray.count);
    }];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
    //only one column in picker
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_listArray count];
}



-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_listArray objectAtIndex:row];
}

-(IBAction)updateChoice:(id)sender {
    
    NSLog(@"%@", _listArray);
    NSString *select = [_listArray objectAtIndex:[_listPicker selectedRowInComponent:0]];
    
    NSString *title = [[NSString alloc] initWithFormat:@"You're going to play %@'s playlist", select];
    
    _listChoice = [[UILabel alloc]initWithFrame:CGRectMake(-100, 300, 1000, 100)];//Set frame of label in your viewcontroller.
    [_listChoice setBackgroundColor:[UIColor lightGrayColor]];//Set background color of label.
    [_listChoice setText:title];//Set text in label.
    [_listChoice setTextColor:[UIColor blackColor]];//Set text color in label.
    [_listChoice setTextAlignment:NSTextAlignmentCenter];//Set text alignment in label.
    [_listChoice setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [_listChoice setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    [_listChoice setNumberOfLines:3];//Set number of lines in label.
    [_listChoice setClipsToBounds:YES];//Set its to YES for Corner radius to work.
    [self.view addSubview:_listChoice];//Add it to the view of your choice.

}

    
- (void)showPlayer {
    
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * ViewController = [storybord   instantiateViewControllerWithIdentifier:@"playerPage"] ;
    [self presentViewController:ViewController animated:YES completion:nil ];
        self.infoWindow.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.infoWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.definesPresentationContext = YES;
    //    [self presentViewController:self.infoWindow animated:NO completion:nil];
   }

- (IBAction)infoClicked:(id)sender {

    [self showPlayer];

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


//- (void)closePlayer {
//    
////    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////    UIViewController * infoWindow = [storybord   instantiateViewControllerWithIdentifier:@"logInPage"] ;
//    [self dismissViewControllerAnimated:YES completion:nil];
//    self.infoWindow.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.infoWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    self.definesPresentationContext = YES;
//}
//
//- (IBAction)closeClicked:(id)sender {
//    [self closePlayer];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
