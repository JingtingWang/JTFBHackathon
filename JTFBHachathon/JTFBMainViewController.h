//
//  JTFBMainViewController.h
//  JTFBHachathon
//
//  Created by Jingting Wang on 3/29/14.
//  Copyright (c) 2014 JT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTFBMainViewController : UIViewController<UITabBarDelegate,UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITabBar *mainTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *searchTabItemBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *homeTabBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *favoriteTabBarItem;

@end
