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
#import <QuartzCore/QuartzCore.h>
#import "JTFBFriendRestaurantCheckin.h"


#define DEGREES_TO_RADIANS(degrees) degrees * M_PI / 180
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

@interface JTFBMainViewController ()
@property (strong, nonatomic)UIView *searchView;
@property (strong, nonatomic)UIView *mainView;
@property (strong, nonatomic)UIView *heartView;
@property (strong, nonatomic)UIPickerView *filterPickerView;
@property (strong, nonatomic)UILabel *promptLabel;
@property (strong, nonatomic)NSArray *testArray;
@property (strong, nonatomic)UIImageView *winston;

@property (nonatomic, strong)UIDynamicAnimator * animator;
@property (nonatomic, strong)UILabel *resultLabel;

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
    
    // configure tab icons
    UIImage *homeIcon = [UIImage imageWithImage:[UIImage imageNamed:@"home_icon"]  scaledToSize:CGSizeMake(20, 20)];
    self.homeTabBarItem.image = homeIcon;
    
    UIImage *searchIcon = [UIImage imageWithImage:[UIImage imageNamed:@"search_icon"]  scaledToSize:CGSizeMake(20, 20)];
    self.searchTabItemBar.image = searchIcon;
    
    UIImage *heartIcon = [UIImage imageWithImage:[UIImage imageNamed:@"heart_icon"]  scaledToSize:CGSizeMake(20, 20)];
    self.favoriteTabBarItem.image = heartIcon;

    [self.view addSubview:self.mainView];
    [self.mainTabBar setSelectedItem:self.homeTabBarItem];
    [self.view bringSubviewToFront:self.mainTabBar];
    
     self.testArray = @[@"w",@"r",@"6",@"9",@"10"];
}

-(void)makeRequestForUserData
{
      [FBRequestConnection startWithGraphPath:@"me?fields=friends.limit(10).fields(checkins.limit(10).fields(place.fields(category,name,location)),name)"
                            completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                if (!error) {
                                    // Sucess! Include your code to handle the results here
//                                    NSDictionary* mydict =  [[result objectForKey:@"friends"]objectForKey:@"data"];
                                    NSMutableArray *temp = [NSMutableArray new];
                                    for (JTFBFriendRestaurantCheckin* aFriendCheckins in  [self getListOfFriendsRestaurant:result])
                                    {
                                        for (NSString * stringR in  aFriendCheckins.restaurants) {
                                            [temp addObject:stringR];
                                        }
                                    }
                                    
                                    self.testArray = [temp copy];
                                    
                                    NSLog(@"user events: %@", self.testArray);
//                                    self.promptLabel.hidden = YES;
                                    self.resultLabel.hidden = NO;
                                    self.promptLabel.text = self.testArray[0];
                                } else {
                                    // An error occurred, we need to handle the error
                                    // See: https://developers.facebook.com/docs/ios/errors
                                }
                            }];
}


-(void)sendRequest
{
    
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"user_friends", @"friends_checkins"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has:
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted
                                               NSLog(@"new permissions %@", [FBSession.activeSession permissions]);
                                               // We can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // See: https://developers.facebook.com/docs/ios/errors
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}





-(UIView *)mainView
{
    if (!_mainView) {
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 500)];
        _mainView.backgroundColor = [UIColor lightGrayColor];
        
        self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:_mainView];
        
        FBLoginView *loginView = [[FBLoginView alloc] init];
        loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
    
        
        // shake then pick restaurant
        UILabel *shareInstruction = [[UILabel alloc]initWithFrame:CGRectMake(45, 70, 230, 60)];
        shareInstruction.numberOfLines = 0;
        shareInstruction.preferredMaxLayoutWidth = 200.0;
        shareInstruction.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        shareInstruction.textColor =  UIColorFromHex(0xF88181);
        shareInstruction.text = @"Shake your phone to get the suggested restaurant!";

        // UIButton
        UIButton * showFilterOptionsButton = [[UIButton alloc]initWithFrame:CGRectMake(80, 130, 150, 50)];
        [showFilterOptionsButton setTitle:@"Show/Hide filters" forState:UIControlStateNormal];
        showFilterOptionsButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        showFilterOptionsButton.titleLabel.textColor = [UIColor whiteColor];
        showFilterOptionsButton.backgroundColor = UIColorFromHex(0x72A0EE);
        showFilterOptionsButton.layer.cornerRadius = 5.0;
        [showFilterOptionsButton addTarget:self action:@selector(sendRequest) forControlEvents:UIControlEventTouchUpInside];
        showFilterOptionsButton.hidden = NO;
        
        
        //checkbox button
        UIButton *checkboxMFButton = [[UIButton alloc]initWithFrame:CGRectMake(80, 140, 20, 20)];
        checkboxMFButton.backgroundColor = UIColorFromHex(0x72A0EE);
        checkboxMFButton.tag = 1;
        UILabel *mfLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 135, 200, 30)];
        mfLabel.text = @"My favorites";
        [checkboxMFButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *checkboxMFFButton =  [[UIButton alloc]initWithFrame:CGRectMake(80, 170, 20, 20)];
        checkboxMFFButton.backgroundColor = UIColorFromHex(0xF88181);
        checkboxMFFButton.tag = 2;
        [checkboxMFFButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *mffLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 165, 200, 30)];
        mffLabel.text = @"My friends favorites";
        
        
        // promptlabel
        self.promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 200, 200, 50)];
        self.promptLabel.text = @"Your result is coming!!";
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        self.promptLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.promptLabel.textColor = [UIColor whiteColor];
        self.promptLabel.backgroundColor = UIColorFromHex(0x72A0EE);

        
        // result label
        self.resultLabel  = [[UILabel alloc]initWithFrame:CGRectMake(60, 200, 200, 50)];
        self.resultLabel.text = @"fdafsa";
        self.resultLabel.textAlignment = NSTextAlignmentCenter;
        self.resultLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.resultLabel.textColor = [UIColor blackColor];
//        self.resultLabel.hidden = YES;
        
        // winston view
        UIImage * winstonImage = [UIImage imageNamed:@"winston"];
        UIImageView * winston = [[UIImageView alloc]initWithImage:winstonImage];
        winston.frame = CGRectMake(100, 250, 100, 130);
        self.winston = winston;
        
        //add subviews
        [_mainView addSubview:loginView];
        [_mainView addSubview:shareInstruction];
//        [_mainView addSubview:showFilterOptionsButton];
        [_mainView addSubview:self.filterPickerView];
        [_mainView addSubview:self.promptLabel];
        [_mainView addSubview:winston];
        [_mainView addSubview:mfLabel];
        [_mainView addSubview:mffLabel];
        [_mainView addSubview:checkboxMFButton];
        [_mainView addSubview:checkboxMFFButton];
        [_mainTabBar addSubview:self.resultLabel];
        
        self.promptLabel.hidden = YES;
        self.filterPickerView.hidden = YES;
        
        UIAttachmentBehavior * attachBalloon = [[UIAttachmentBehavior alloc]initWithItem:winston attachedToAnchor:CGPointMake(160, 50)];
        
        UIPushBehavior *pushBalloon = [[UIPushBehavior alloc]initWithItems:@[winston] mode:UIPushBehaviorModeInstantaneous];
        [pushBalloon setAngle:DEGREES_TO_RADIANS(0) magnitude:2.0];

          UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[winston]];
        
        [self.animator addBehavior:attachBalloon];
        [self.animator addBehavior:pushBalloon];
        [self.animator addBehavior:gravity];

    }
    
    return _mainView;
    
}

-(void)selected:(UIButton*)sender
{
    if (sender.tag == 1){
        if (sender.backgroundColor !=[UIColor blueColor]) {
            sender.backgroundColor = [UIColor blueColor];
        }else{
             sender.backgroundColor = UIColorFromHex(0x72A0EE);
        }
    }
    
    if (sender.tag == 2){
        if (sender.backgroundColor !=[UIColor blueColor]) {
            sender.backgroundColor = [UIColor blueColor];
        }else{
            sender.backgroundColor = UIColorFromHex(0xF88181);
        }
    }

}

-(void)showHideFilter
{
    if (self.filterPickerView.hidden == YES) {
        self.filterPickerView.hidden = NO;
    }else{
        self.filterPickerView.hidden = YES;
    }
    

}

//-(UIPickerView *)filterPickerView
//{
//    if (!_filterPickerView) {
//        _filterPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(70, 170, 100, 150)];
//        _filterPickerView.delegate = self;
//        _filterPickerView.dataSource = self;
//    }
//    
//    return _filterPickerView;
//}


-(UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(10, 200, 300, 200)];
        _searchView.backgroundColor = [UIColor blackColor];
    }
    return _searchView;
}


-(UIView *)heartView
{
    if (!_heartView) {
        _heartView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 500)];
        
        UITableView *myFavoriteTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
        myFavoriteTableView.delegate = self;
        myFavoriteTableView.dataSource = self;
        
        UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        headLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        headLabel.textColor = UIColorFromHex(0x72A0EE);
        headLabel.text = @"My friends' favorite restaurants list";
        myFavoriteTableView.tableHeaderView = headLabel;
        myFavoriteTableView.tableFooterView = nil;
        
        _heartView.backgroundColor = [UIColor blueColor];
        
        [_heartView addSubview:myFavoriteTableView];
    }
    return _heartView;
}


#pragma mark -- UITabBarDelegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"didSelectItem: %d", item.tag);
    [self removeMySubviews];

    
    switch (item.tag) {
         case 0:
            [self.view addSubview:self.mainView];
            [self.view bringSubviewToFront:self.mainTabBar];

            break;
        case 1:
            [self.view addSubview:self.searchView];
            [self.view bringSubviewToFront:self.mainTabBar];

            break;
        case 2:
            [self.view addSubview:self.heartView];
            [self.view bringSubviewToFront:self.mainTabBar];

            break;
        default:
            break;
    }

}


#pragma mark -- UIPickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     return @"hahaha";

}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return  30.0;
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *l = [UILabel new];
    l.text = @"fb";
    l.backgroundColor = [UIColor clearColor];
    return  l;
    
}


#pragma mark -- private
-(void)removeMySubviews
{
     for(UIView *view in [self.view subviews] )
     {
         if (![view isKindOfClass:[UITabBar class]]) {
             [view removeFromSuperview];
         }
     }
}

- (NSArray *)getListOfFriendsRestaurant:(id)result
{
    NSMutableArray *friendsWithCheckins = [[NSMutableArray alloc] init];
    
    NSDictionary *friends = [(NSDictionary *)result objectForKey:@"friends"];
    NSArray *data = [friends objectForKey:@"data"];
    
    for (id aFriendOrCheckIn in data) {
        NSDictionary *checkins = [aFriendOrCheckIn objectForKey:@"checkins"];
        if (checkins != nil) {
            JTFBFriendRestaurantCheckin *friendsRestaurant = [[JTFBFriendRestaurantCheckin alloc] init];
            NSString *name = [aFriendOrCheckIn objectForKey:@"name"];
            if (name != nil) {
                friendsRestaurant.name = name;
            }
            NSArray *checkinData = [checkins objectForKey:@"data"];
            for (id aRestaurant in checkinData) {
                NSDictionary *restaurant = [aRestaurant objectForKey:@"place"];
                NSString *category = [restaurant objectForKey:@"category"];
                if ([category isEqual:@"Restaurant/cafe"]) {
                    NSString *restaurantName = [restaurant objectForKey:@"name"];
                    [friendsRestaurant.restaurants addObject:restaurantName];
                }
            }
            [friendsWithCheckins addObject:friendsRestaurant];
        }
        
    }
    return friendsWithCheckins;
}


#pragma mark -- UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.testArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *defaultString = @"default";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(cell == nil )
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultString];
    }
    
    cell.textLabel.text = self.testArray[indexPath.row];
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // Do your thing after shaking device
    self.promptLabel.hidden = NO;
//    self.resultLabel.hidden = YES;
    UIPushBehavior *pushBalloon = [[UIPushBehavior alloc]initWithItems:@[self.winston] mode:UIPushBehaviorModeInstantaneous];
    [pushBalloon setAngle:DEGREES_TO_RADIANS(0) magnitude:4.0];
    
    [self.animator addBehavior:pushBalloon];

    [self sendRequest];
}

@end
