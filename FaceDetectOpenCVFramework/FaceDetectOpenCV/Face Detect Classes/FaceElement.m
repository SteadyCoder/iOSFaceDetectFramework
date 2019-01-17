//
//  HLGFaceElement.m
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/16/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import "FaceElement.h"

@implementation FaceElement

- (instancetype)init {
    self = [super init];
    if (self) {
        self.width = 0;
        self.height = 0;
        self.position = CGPointZero;
    }
    return self;
}

- (instancetype)initWithPoints:(NSArray<NSValue *> *)points {
    self = [self init];
    if (self) {
        _elementPoints = points;
    }
    return self;
}

@end

@implementation ChinElement

@end

@implementation MouthElement

@end
