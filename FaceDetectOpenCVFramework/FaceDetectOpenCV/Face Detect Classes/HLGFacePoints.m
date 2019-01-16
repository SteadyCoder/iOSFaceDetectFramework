//
//  HLGFacePoints.m
//  Halogram
//
//  Created by Ira on 02.04.18.
//  Copyright © 2018 krestone. All rights reserved.
//

#import "HLGFacePoints.h"
#import "HLGFaceElement.h"

//OpenCV returns 68 face points
//From 0 to 16 its chin points, from 17 to 21 its left eyebrow points etc
typedef NS_ENUM(NSUInteger, HLGPointType) {
    HLGRightCheek = 0,
    HLGChin = 8,
    HLGLeftCheek = 16,
    
    HLGLeftEyebrowStart = 17,
    HLGLeftEyebrowCenter = 19,
    HLGLeftEyebrowEnd = 21,
    
    HLGRightEyebrowStart = 22,
    HLGRightEyebrowCenter = 24,
    HLGRightEyebrowEnd = 26,
    
    HLGNoseStart = 27,
    HLGNoseCenter = 33,
    HLGNoseEnd = 35,
    
    HLGLeftEyeLeftTip = 36,
    HLGLeftEyeRightTip = 39,
    HLGLeftEyeEnd = 41,
    
    HLGRightEyeLeftTip = 42,
    HLGRightEyeRightTip = 45,
    HLGRightEyeEnd = 47,
    
    HLGMouthStart = 48,
    HLGMouthCenter = 62,
    HLGMouthEnd = 67
};


@implementation HLGFacePoints

- (instancetype)initWithFaceDetectedPoints:(NSMutableArray *)facePoints {
    if (self = [super init]) {
        // Chin
        _chinPoints = [facePoints subarrayWithRange:NSMakeRange(HLGRightCheek, HLGLeftCheek + 1)];
        _chin = [[HLGFaceElement alloc] initWithPoints:_chinPoints];
        _chinCenterPoint = [[facePoints objectAtIndex:HLGChin] CGPointValue];
        _chin.centre = _chinCenterPoint;
        _chin.width = [self getChinWidth];
        _chin.height = [self getChinHeight];
        // Left eye brow
        _leftEyebrowPoints = [facePoints subarrayWithRange:NSMakeRange(HLGLeftEyebrowStart , HLGLeftEyebrowEnd - HLGLeftEyebrowStart + 1)];
        _leftEyeBrow = [[HLGFaceElement alloc] initWithPoints:_leftEyebrowPoints];
        // Right eye brow
        _rightEyebrowPoints = [facePoints subarrayWithRange:NSMakeRange(HLGRightEyebrowStart, HLGRightEyebrowEnd - HLGRightEyebrowStart + 1)];
        _rightEyeBrow = [[HLGFaceElement alloc] initWithPoints:_rightEyebrowPoints];
        // Nose
        _nosePoints = [facePoints subarrayWithRange:NSMakeRange(HLGNoseStart, HLGNoseEnd - HLGNoseStart + 1)];
        _nose = [[HLGFaceElement alloc] initWithPoints:_nosePoints];
        _noseCenterPoint = [facePoints[HLGNoseCenter] CGPointValue];
        _nose.centre = _noseCenterPoint;
        // Left eye
        _leftEyePoints = [facePoints subarrayWithRange:NSMakeRange(HLGLeftEyeLeftTip, HLGLeftEyeEnd - HLGLeftEyeLeftTip + 1)];
        _leftEye = [[HLGFaceElement alloc] initWithPoints:_leftEyePoints];
        _leftEyeCenterPoint = [self getCenterBtwFirstPoint:[[facePoints objectAtIndex:HLGLeftEyeLeftTip] CGPointValue] andSecondPoint:[[facePoints objectAtIndex:HLGLeftEyeRightTip] CGPointValue]];
        _leftEye.centre = _leftEyeCenterPoint;
        // Right eye
        _rightEye = [[HLGFaceElement alloc] initWithPoints:_rightEyePoints];
        _rightEyePoints = [facePoints subarrayWithRange:NSMakeRange(HLGRightEyeLeftTip, HLGRightEyeEnd - HLGRightEyeLeftTip + 1)];
        _rightEyeCenterPoint = [self getCenterBtwFirstPoint:[[facePoints objectAtIndex:HLGRightEyeRightTip] CGPointValue] andSecondPoint:[[facePoints objectAtIndex:HLGRightEyeLeftTip] CGPointValue]];
        _rightEye.centre = _rightEyeCenterPoint;
        // Mouth
        _mouthPoints = [facePoints subarrayWithRange:NSMakeRange(HLGMouthStart, HLGMouthEnd - HLGMouthStart + 1)];
        _mouth = [[HLGFaceElement alloc] initWithPoints:_mouthPoints];
        _mouthCenterPoint = [self getCenterBtwFirstPoint:[[facePoints objectAtIndex:HLGMouthCenter] CGPointValue] andSecondPoint:[[facePoints objectAtIndex:HLGMouthEnd - 1] CGPointValue]];
        _mouth.centre = _mouthCenterPoint;
        
        // Other
        _rightEyeTop = [[facePoints objectAtIndex:43] CGPointValue];
        _rightEyeDown = [[facePoints objectAtIndex:46] CGPointValue];
        _centerBetweenEyesPoint = [self getCenterBtwFirstPoint:self.leftEyeCenterPoint andSecondPoint:self.rightEyeCenterPoint];
        
        _allPointsFromOpenCV = facePoints;
        CGPoint rightCheek = [[facePoints objectAtIndex:HLGRightCheek] CGPointValue];
        CGPoint leftCheek = [[facePoints objectAtIndex:HLGLeftCheek] CGPointValue];
        _angleOfHead = atan2(fabs(rightCheek.y - leftCheek.y), rightCheek.x - leftCheek.x) * 180 / M_PI;
        if (leftCheek.y > rightCheek.y) {
            _angleOfHead -= 180;
        } else {
            _angleOfHead = 180 - _angleOfHead;
        }
    }
    return self;
}

- (CGPoint)getCenterBtwFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint {
    return CGPointMake((secondPoint.x + firstPoint.x)/2, (secondPoint.y + firstPoint.y)/2);
}

- (CGFloat)getLengthBtwFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint {
    return sqrt((secondPoint.x - firstPoint.x) * (secondPoint.x - firstPoint.x) + (secondPoint.y - firstPoint.y) * (secondPoint.y - firstPoint.y));
}

- (CGFloat)getChinWidth {
    return self.chin.elementPoints.lastObject.CGPointValue.x - self.chin.elementPoints.firstObject.CGPointValue.x;
}

- (CGFloat)getChinHeight {
    CGPoint startPoint = self.chin.elementPoints.firstObject.CGPointValue;
    CGPoint endPoint = self.chin.elementPoints.lastObject.CGPointValue;
    CGPoint centreBetweenPoints = [self getCenterBtwFirstPoint:startPoint andSecondPoint:endPoint];
    
    // Distance between top centre point of chin and bottom centre point of chin
    CGFloat chinHeight =  self.chin.centre.y - centreBetweenPoints.y;
    
    return chinHeight * 2;
}


@end
