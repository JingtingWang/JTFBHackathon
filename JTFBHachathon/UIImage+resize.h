//
//  UIImage+resize.h
//  JTFBHachathon
//
//  Created by Jingting Wang on 3/29/14.
//  Copyright (c) 2014 JT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (resize)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
