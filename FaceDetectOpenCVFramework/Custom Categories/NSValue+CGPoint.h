//
//  NSValue+CGPoint.h
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/17/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSValue (CGPoint)

+ (NSValue *)valueFromCGPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
