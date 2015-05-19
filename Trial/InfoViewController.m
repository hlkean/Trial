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
@property (nonatomic, strong) NSArray *listArray;
@end

@implementation InfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *data = [[NSArray alloc] initWithObjects:@"dumps", @"dumper", @"dumpiest", nil];
    self.listArray = data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








-(IBAction)updateChoice:(id)sender {
    
    
    NSString *select = [_listArray objectAtIndex:[_listPicker selectedRowInComponent:0]];
    
    NSString *title = [[NSString alloc] initWithFormat:@"You're going to play %@'s playlist", select];
    
    _listChoice = [[UILabel alloc]initWithFrame:CGRectMake(150, 300, 500, 100)];//Set frame of label in your viewcontroller.
    [_listChoice setBackgroundColor:[UIColor lightGrayColor]];//Set background color of label.
    [_listChoice setText:title];//Set text in label.
    [_listChoice setTextColor:[UIColor blackColor]];//Set text color in label.
    [_listChoice setTextAlignment:NSTextAlignmentCenter];//Set text alignment in label.
    [_listChoice setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [_listChoice setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    [_listChoice setNumberOfLines:1];//Set number of lines in label.
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

#pragma mark ListPicker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
    //only one column in picker
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_listArray count];
}

#pragma mark ListPicker Delegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_listArray objectAtIndex:row];
}
@end
