//
//  NSValue+CGPoint.m
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/17/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import "NSValue+CGPoint.h"

@implementation NSValue (CGPoint)

+ (NSValue *)valueFromCGPoint:(CGPoint)point {
    return [NSValue valueWithCGPoint:point];
}

@end
