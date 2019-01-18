//
//  FacePoint.m
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/18/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import "FacePoint.h"

@implementation FacePoint

+ (instancetype)nullPoint {
    static FacePoint *point = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        point = [[self alloc] initWithX:0 andY:0 andZ:0];
    });
    return point;
}

+ (instancetype)facePointWithX:(CGFloat)x andY:(CGFloat)y {
    return [[FacePoint alloc] initWithX:x andY:y];
}

+ (instancetype)facePointWithX:(CGFloat)x andY:(CGFloat)y andZ:(CGFloat)z {
    return [[FacePoint alloc] initWithX:x andY:y andZ:z];
}

- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y andZ:(CGFloat)z {
    self = [self initWithX:x andY:y];
    if (self) {
        _z = z;
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)pointArray {
    switch (pointArray.count) {
        case 3:
            self = [self initWithX:[pointArray[0] floatValue] andY:[pointArray[1] floatValue] andZ:[pointArray[2]floatValue]];
            break;
        case 2:
            self = [self initWithX:[pointArray[0] floatValue] andY:[pointArray[1] floatValue]];
        default:
            self = [super init];
            break;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%f %f %f", self.x, self.y, self.z];
}


@end
