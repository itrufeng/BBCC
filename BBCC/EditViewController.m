//
//  EditViewController.m
//  BBCC
//
//  Created by Jian Zhang on 7/15/15.
//  Copyright © 2015 Steve (Zhang Jian). All rights reserved.
//

#import "EditViewController.h"
#import "AppDelegate.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *hostField;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hostField.text = [((AppDelegate *)[UIApplication sharedApplication].delegate) host];
}

- (IBAction)onSave:(id)sender {
    [((AppDelegate *)[UIApplication sharedApplication].delegate) saveHost:_hostField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
