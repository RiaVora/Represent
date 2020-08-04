//
//  LaunchViewController.m
//  Represent
//
//  Created by Ria Vora on 8/4/20.
//  Copyright © 2020 Ria Vora. All rights reserved.
//

#import "LaunchViewController.h"
#import <ChameleonFramework/Chameleon.h>


@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.frame andColors:@[[UIColor colorWithHexString:@"ffffff"], [UIColor colorWithHexString:@"FFCCCE"]]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
