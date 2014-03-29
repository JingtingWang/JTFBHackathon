//
//  JTFBMainViewController.m
//  JTFBHachathon
//
//  Created by Jingting Wang on 3/28/14.
//  Copyright (c) 2014 JT. All rights reserved.
//

#import "JTFBMainViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIImage+resize.h"

@interface JTFBMainViewController ()
@property (strong, nonatomic)UIView *searchView;
@property (strong, nonatomic)UIView *mainView;
@property (strong, nonatomic)UIView *heartView;

@end

@implementation JTFBMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Find food near ME";
    
    self.mainTabBar.delegate = self;
    
//    FBLoginView *loginView = [[FBLoginView alloc] init];
//    // Align the button in the center horizontally
//    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
//    [self.view addSubview:loginView];
    
    // configure tab icons
    UIImage *homeIcon = [UIImage imageWithImage:[UIImage imageNamed:@"home_icon"]  scaledToSize:CGSizeMake(20, 20)];
    self.homeTabBarItem.image = homeIcon;
    
    UIImage *searchIcon = [UIImage imageWithImage:[UIImage imageNamed:@"search_icon"]  scaledToSize:CGSizeMake(20, 20)];
    self.searchTabItemBar.image = searchIcon;
    
    UIImage *heartIcon = [UIImage imageWithImage:[UIImage imageNamed:@"heart_icon"]  scaledToSize:CGSizeMake(20, 20)];
    self.favoriteTabBarItem.image = heartIcon;
    
}



-(UIView *)mainView
{
    if (_mainView) {
        _mainView = 
    }
    
    return _mainView;



}


#pragma mark -- UITabBarDelegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"didSelectItem: %d", item.tag);
    
    switch (item.tag) {
        case 0:
//            [self.navigationController initWithRootViewController:self];
            break;
        case 1:
//            [self.presentedViewController presentViewController:self.searchVC animated:NO completion:nil];
            break;
        case 2:
//            [self.navigationController pushViewController:self.heartVC animated:YES];
            
        default:
            break;
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
