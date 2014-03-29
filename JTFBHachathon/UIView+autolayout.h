//
//  UIView+Autolayout.h
//  ModCloth-iOS-app
//
//  Created by Christopher Pickslay on 10/16/13.
//  Copyright (c) 2013 ModCloth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIViewAutoLayoutStyleLeft,
    UIViewAutoLayoutStyleRight,
    UIViewAutoLayoutStyleVertical,
    UIViewAutoLayoutStyleStackedVertical,
    UIViewAutoLayoutStyleStackedHorizontal,
} UIViewAutoLayoutStyle;

@interface UIView (autolayout)

-(void)removeAllSubviews;

/**
 Add autolayout constraints
 */
-(void)addConstraintsFromDescriptions:(NSArray*)constraintDescriptions metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

/**
 Add autolayout constraints with options
 */
-(void)addConstraintsFromDescriptions:(NSArray*)constraintDescriptions options:(NSLayoutFormatOptions)options metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

/**
 Add subviews and add autolayout constraints
 */
-(void)addSubviews:(NSDictionary *)views constraints:(NSArray*)constraintDescriptions options:(NSLayoutFormatOptions)options metrics:(NSDictionary*)metrics;

/**
 Add a subview, and add constriants so that it's contained within the view using insets provided
 */
-(void)addSubview:(UIView *)view containedWithInsets:(UIEdgeInsets)insets;

/*!
 Add an autolayout constraint centering two sibling child views horizontally
 */
-(void)centerSiblingHorizontally:(UIView*)sibling1 withSibling:(UIView*)sibling2;

/*!
 Add an autolayout constraint centering two sibling child views vertically
 */
-(void)centerSiblingVertically:(UIView*)sibling1 withSibling:(UIView*)sibling2;

/**
 Add an autolayout constraint centering `childView` horizontally in the current view
 */
-(void)centerChildHorizontally:(UIView *)childView;

/**
 Add an autolayout constraint centering `childView` vertically in the current view
 */
-(void)centerChildVertically:(UIView *)childView;

/**
 Add a subview and constraintst to center it within the current view
 */
-(void)addSubviewCentered:(UIView*)view;

/**
 Add an autolayout constraints to set the current view's size
 */
-(void)setAutolayoutSize:(CGSize)size;
-(void)setAutolayoutHeight:(CGFloat)height;
-(void)setAutolayoutWidth:(CGFloat)width;
-(void)removeAutolayoutSizeConstraints;

/**
 Align the baseline of views to a base view
 */
-(void)alignBaselinesOfViews:(NSArray*)views toView:(UIView*)baseView;

/**
 Create a container with the specified subviews and gap using autolayout. See also `containerViewWithSubviews:layoutStyle:paddingInsets:maxWidth:`
 
 @param subviews Array of views to add to the container view
 @param layoutStyle The method to arrange the subviews
 @param gap The number of points of space to put between the subviews
 @return A UIView sized to fit all of the subviews
 */
+(UIView *)containerWithViews:(NSArray *)views layoutStyle:(UIViewAutoLayoutStyle)layoutStyle gap:(NSInteger)gap;

@end
