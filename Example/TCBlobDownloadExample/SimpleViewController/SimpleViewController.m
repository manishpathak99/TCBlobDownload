//
//  ViewController.m
//  TCBlobDownloadExample
//
//  Created by Thibault Charbonnier on 18/04/13.
//  Copyright (c) 2013 thibaultCha. All rights reserved.
//

#import "SimpleViewController.h"
#import "MultipleViewController.h"

@implementation SimpleViewController


bool resume = false;
#pragma mark - Init


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sharedDownloadManager = [TCBlobDownloadManager sharedInstance];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Demo


- (IBAction)download:(id)sender
{
    // Delegate
    /*
    [self.sharedDownloadManager startDownloadWithURL:[NSURL URLWithString:self.urlField.text]
                                          customPath:nil
                                            delegate:self];
    */
    
    // Blocks
    // progress = progress*100;
    [self.sharedDownloadManager startDownloadWithURL:[NSURL URLWithString:self.urlField.text]
                                          customPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"example"]]
                                       firstResponse:NULL
                                            progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
                                                if (remainingTime != -1) {
                                                    [self.remainingTime setText:[NSString stringWithFormat:@"%lds", (long)remainingTime]];
                                                }
                                                progress = progress*100;
                                                NSLog(@"%f", progress);
                                            }
                                               error:^(NSError *error) {
                                                   NSLog(@"%@", error);
                                               }
                                            complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                                NSString *str = downloadFinished ? @"Completed" : @"Cancelled";
                                                [self.remainingTime setText:str];
                                            }];
    [self.urlField resignFirstResponder];
}


#pragma mark - TCBlobDownloaderDelegate


- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{

}

- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
{

}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
{

}

- (void)download:(TCBlobDownloader *)blobDownload didCancelRemovingFile:(BOOL)fileRemoved
{
    
}

- (void)download:(TCBlobDownloader *)blobDownload didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile
{

}


#pragma mark - Utilities


- (IBAction)pauseResumeBtnAction:(id)sender {
    NSLog(@"Click resume");
    if(resume == true) {
        [self.sharedDownloadManager startDownloadWithURL:[NSURL URLWithString:self.urlField.text]
                                              customPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"example"]]
                                           firstResponse:NULL
                                                progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
                                                    if (remainingTime != -1) {
                                                        [self.remainingTime setText:[NSString stringWithFormat:@"%lds", (long)remainingTime]];
                                                    }
                                                    progress = progress*100;
                                                    NSLog(@"%f %% ", progress);
                                                }
                                                   error:^(NSError *error) {
                                                       NSLog(@"%@", error);
                                                   }
                                                complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                                    NSString *str = downloadFinished ? @"Completed" : @"Cancelled";
                                                    [self.remainingTime setText:str];
                                                }];
        resume = false;

    } else {
        [self.sharedDownloadManager cancelAllDownloadsAndRemoveFiles:false];
        resume = true;
    }
    
    
}

- (void)cancelAll:(id)sender
{
    [self.sharedDownloadManager cancelAllDownloadsAndRemoveFiles:YES];
}

- (IBAction)switchToMultipleDownloads:(id)sender
{
    MultipleViewController *multipleViewController = [MultipleViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:multipleViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
