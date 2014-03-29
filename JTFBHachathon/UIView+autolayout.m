//
//  UIView+Autolayout.m
//  ModCloth-iOS-app
//
//  Created by Christopher Pickslay on 10/16/13.
//  Copyright (c) 2013 ModCloth. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (autolayout)

-(void)removeAllSubviews
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

-(void)addConstraintsFromDescriptions:(NSArray*)constraintDescriptions metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    [self addConstraintsFromDescriptions:constraintDescriptions options:0 metrics:metrics views:views];
}

-(void)addConstraintsFromDescriptions:(NSArray*)constraintDescriptions options:(NSLayoutFormatOptions)options metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    for (UIView *view in [views allValues]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    for (NSString *constraintDescription in constraintDescriptions) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constraintDescription options:options metrics:metrics views:views]];
    }
}

-(void)addSubviews:(NSDictionary *)views
       constraints:(NSArray*)constraintDescriptions
           options:(NSLayoutFormatOptions)options
           metrics:(NSDictionary*)metrics
{
    for (UIView *view in [views allValues] ) {
        if (![view conformsToProtocol:@protocol(UILayoutSupport)]) {
            [self addSubview:view];
        }
    }
    [self addConstraintsFromDescriptions:constraintDescriptions
                                 options:options
                                 metrics:metrics
                                   views:views];
}

-(void)addSubviewCentered:(UIView*)view
{
    [self addSubview:view];
    [self centerChildHorizontally:view];
    [self centerChildVertically:view];
}

-(void)addSubview:(UIView *)view containedWithInsets:(UIEdgeInsets)insets
{
    NSDictionary *metrics = @{@"top":@(insets.top),
                              @"bottom":@(insets.bottom),
                              @"left":@(insets.left),
                              @"right":@(insets.right),
                              };
    NSDictionary *views = @{@"view":view};
    NSArray *constraints = @[@"V:|-top-[view]-bottom-|",
                             @"H:|-left-[view]-right-|",
                             ];
    [self addSubviews:views
          constraints:constraints
              options:0
              metrics:metrics];
    
}

-(void)centerSiblingHorizontally:(UIView*)sibling1 withSibling:(UIView*)sibling2
{
    sibling1.translatesAutoresizingMaskIntoConstraints = NO;
    sibling2.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerHorizontally = [NSLayoutConstraint constraintWithItem:sibling1
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:sibling2
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1 constant:0];
    [self addConstraint:centerHorizontally];
}

-(void)centerSiblingVertically:(UIView*)sibling1 withSibling:(UIView*)sibling2
{
    sibling1.translatesAutoresizingMaskIntoConstraints = NO;
    sibling2.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerVertically = [NSLayoutConstraint constraintWithItem:sibling1
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:sibling2
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1 constant:0];
    [self addConstraint:centerVertically];
}

-(void)alignBaselinesOfViews:(NSArray*)views toView:(UIView*)baseView
{
    for (UIView *view in views) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *baseline = [NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeBaseline
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:baseView
                                                                    attribute:NSLayoutAttributeBaseline
                                                                   multiplier:1
                                                                     constant:0];
        [self addConstraint:baseline];
    }
}

-(void)centerChildHorizontally:(UIView *)childView
{
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerHorizontally = [NSLayoutConstraint constraintWithItem:childView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1 constant:0];
    [self addConstraint:centerHorizontally];
}

-(void)centerChildVertically:(UIView *)childView
{
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerVertically = [NSLayoutConstraint constraintWithItem:childView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1 constant:0];
    [self addConstraint:centerVertically];
}

+(UIView *)containerWithViews:(NSArray *)views layoutStyle:(UIViewAutoLayoutStyle)layoutStyle gap:(NSInteger)gap
{
    UIView *container = [UIView new];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < views.count; i++) {
        BOOL isLast = (i == views.count -1);
        BOOL isFirst = (i == 0);
        
        UIView *previousView = isFirst ? nil : views[i-1];
        
        UIView *view = views[i];
        
        [container addSubview:view];
        
        
        //add horizontal constraint
        NSMutableArray *constraints = [NSMutableArray new];
        if (layoutStyle == UIViewAutoLayoutStyleVertical || layoutStyle == UIViewAutoLayoutStyleStackedVertical) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:container
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:0]];
            
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:container
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1
                                                                 constant:0]];
        } else if (layoutStyle == UIViewAutoLayoutStyleLeft || layoutStyle == UIViewAutoLayoutStyleStackedHorizontal) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:container
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:0]];
            
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:container
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1
                                                                 constant:0]];
        }
        
        
        //if first view, top of superview.  Subsequent views align to previous view
        if (layoutStyle == UIViewAutoLayoutStyleVertical || layoutStyle == UIViewAutoLayoutStyleStackedVertical) {
            if(isFirst){
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:container
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1
                                                                     constant:0]];
            } else {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:previousView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1
                                                                     constant:gap]];
                // set the views the same height to each other
                if (layoutStyle == UIViewAutoLayoutStyleVertical) {
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:previousView
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1
                                                                         constant:0]];
                }
            }
            
            //only for last view
            if (isLast) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:container
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1
                                                                     constant:0]];
            }
        } else if (layoutStyle == UIViewAutoLayoutStyleLeft || layoutStyle == UIViewAutoLayoutStyleStackedHorizontal) {
            if(isFirst){
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:container
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1
                                                                     constant:0]];
            } else {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:previousView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1
                                                                     constant:gap]];
                // set the views the same width to each other
                if (layoutStyle == UIViewAutoLayoutStyleLeft) {
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:previousView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1
                                                                         constant:0]];
                }
            }
            
            //only for last view
            if (isLast) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:container
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1
                                                                     constant:0]];
            }
        }
        
        [container addConstraints:constraints];
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return container;
}

-(void)setAutolayoutHeight:(CGFloat)height
{
    for(NSLayoutConstraint* constraint in self.constraints) {
        if(constraint.firstAttribute == NSLayoutAttributeHeight) {
            [self removeConstraint:constraint];
        }
    }
    
    NSDictionary *views = @{@"self":self};
    NSArray *constraints = @[
                             @"V:[self(height)]",
                             ];
    NSDictionary *metrics = @{
                              @"height" :@(height),
                              };
    [self addConstraintsFromDescriptions:constraints metrics:metrics views:views];
}

-(void)setAutolayoutWidth:(CGFloat)width
{
    for(NSLayoutConstraint* constraint in self.constraints) {
        if(constraint.firstAttribute == NSLayoutAttributeWidth) {
            [self removeConstraint:constraint];
        }
    }
    
    NSDictionary *views = @{@"self":self};
    NSArray *constraints = @[
                             @"H:[self(width)]",
                             ];
    NSDictionary *metrics = @{
                              @"width"  :@(width),
                              };
    [self addConstraintsFromDescriptions:constraints metrics:metrics views:views];
}

-(void)removeAutolayoutSizeConstraints
{
    for(NSLayoutConstraint* constraint in self.constraints)
    {
        if((constraint.firstAttribute == NSLayoutAttributeWidth) || (constraint.firstAttribute == NSLayoutAttributeHeight))
        {
            [self removeConstraint:constraint];
        }
    }
}

-(void)setAutolayoutSize:(CGSize)size
{
    for(NSLayoutConstraint* constraint in self.constraints)
    {
        if((constraint.firstAttribute == NSLayoutAttributeWidth) || (constraint.firstAttribute == NSLayoutAttributeHeight))
        {
            [self removeConstraint:constraint];
        }
    }
    NSDictionary *views = @{@"self":self};
    NSArray *constraints = @[
                             @"V:[self(height)]",
                             @"H:[self(width)]",
                             ];
    NSDictionary *metrics = @{
                              @"height" :@(size.height),
                              @"width"  :@(size.width),
                              };
    [self addConstraintsFromDescriptions:constraints metrics:metrics views:views];
}

@end
