//
//  FacePoints.m
//  Halogram
//
//  Created by Ira on 02.04.18.
//  Copyright © 2018 krestone. All rights reserved.
//

#import "FacePoints.h"
#import "FaceElement.h"

//OpenCV returns 68 face points
//From 0 to 16 its chin points, from 17 to 21 its left eyebrow points etc
typedef NS_ENUM(NSUInteger, PointType) {
    RightCheek = 0,
    Chin = 8,
    LeftCheek = 16,
    
    LeftEyebrowStart = 17,
    LeftEyebrowCenter = 19,
    LeftEyebrowEnd = 21,
    
    RightEyebrowStart = 22,
    RightEyebrowCenter = 24,
    RightEyebrowEnd = 26,
    
    NoseStart = 27,
    NoseCenter = 33,
    NoseEnd = 35,
    
    LeftEyeLeftTip = 36,
    LeftEyeRightTip = 39,
    LeftEyeEnd = 41,
    
    RightEyeLeftTip = 42,
    RightEyeRightTip = 45,
    RightEyeEnd = 47,
    
    MouthStart = 48,
    MouthLeftCorner = 48,
    MouthRightCorner = 54,
    MouthCenter = 62,
    MouthEnd = 67
};


@implementation FacePoints

- (instancetype)initWithFaceDetectedPoints:(NSMutableArray<NSValue *> *)facePoints {
    if (self = [super init]) {
        // Chin
        _chinPoints = [facePoints subarrayWithRange:NSMakeRange(RightCheek, LeftCheek + 1)];
        _chin = [[ChinElement alloc] initWithPoints:_chinPoints];
        _chin.centre = _chinCenterPoint;
        _chin.width = [self getChinWidth];
        _chin.height = [self getChinHeight];
        _chin.centre = [self getChinCentre];
        _chin.bottomCentre = [[facePoints objectAtIndex:Chin] CGPointValue];
        // Left eye brow
        _leftEyebrowPoints = [facePoints subarrayWithRange:NSMakeRange(LeftEyebrowStart , LeftEyebrowEnd - LeftEyebrowStart + 1)];
        _leftEyeBrow = [[FaceElement alloc] initWithPoints:_leftEyebrowPoints];
        _leftEyeBrow.centre = facePoints[LeftEyebrowCenter].CGPointValue;
        // Right eye brow
        _rightEyebrowPoints = [facePoints subarrayWithRange:NSMakeRange(RightEyebrowStart, RightEyebrowEnd - RightEyebrowStart + 1)];
        _rightEyeBrow = [[FaceElement alloc] initWithPoints:_rightEyebrowPoints];
        _rightEyeBrow.centre = facePoints[RightEyebrowCenter].CGPointValue;
        // Nose
        _nosePoints = [facePoints subarrayWithRange:NSMakeRange(NoseStart, NoseEnd - NoseStart + 1)];
        _nose = [[FaceElement alloc] initWithPoints:_nosePoints];
        _noseCenterPoint = [facePoints[NoseCenter] CGPointValue];
        _nose.centre = _noseCenterPoint;
        // Left eye
        _leftEyePoints = [facePoints subarrayWithRange:NSMakeRange(LeftEyeLeftTip, LeftEyeEnd - LeftEyeLeftTip + 1)];
        _leftEye = [[FaceElement alloc] initWithPoints:_leftEyePoints];
        _leftEyeCenterPoint = [self getCenterBtwFirstPoint:[[facePoints objectAtIndex:LeftEyeLeftTip] CGPointValue] andSecondPoint:[[facePoints objectAtIndex:LeftEyeRightTip] CGPointValue]];
        _leftEye.centre = _leftEyeCenterPoint;
        // Right eye
        _rightEye = [[FaceElement alloc] initWithPoints:_rightEyePoints];
        _rightEyePoints = [facePoints subarrayWithRange:NSMakeRange(RightEyeLeftTip, RightEyeEnd - RightEyeLeftTip + 1)];
        _rightEyeCenterPoint = [self getCenterBtwFirstPoint:[[facePoints objectAtIndex:RightEyeRightTip] CGPointValue] andSecondPoint:[[facePoints objectAtIndex:RightEyeLeftTip] CGPointValue]];
        _rightEye.centre = _rightEyeCenterPoint;
        // Mouth
        _mouthPoints = [facePoints subarrayWithRange:NSMakeRange(MouthStart, MouthEnd - MouthStart + 1)];
        _mouth = [[MouthElement alloc] initWithPoints:_mouthPoints];
        _mouthCenterPoint = [self getCenterBtwFirstPoint:[[facePoints objectAtIndex:MouthCenter] CGPointValue] andSecondPoint:[[facePoints objectAtIndex:MouthEnd - 1] CGPointValue]];
        _mouth.centre = _mouthCenterPoint;
        _mouth.leftCorner = facePoints[MouthLeftCorner].CGPointValue;
        _mouth.rightCorner = facePoints[MouthRightCorner].CGPointValue;
        
        // Other
        _rightEyeTop = [[facePoints objectAtIndex:43] CGPointValue];
        _rightEyeDown = [[facePoints objectAtIndex:46] CGPointValue];
        _centerBetweenEyesPoint = [self getCenterBtwFirstPoint:self.leftEyeCenterPoint andSecondPoint:self.rightEyeCenterPoint];
        
        _allPointsFromOpenCV = facePoints;
        CGPoint rightCheek = [[facePoints objectAtIndex:RightCheek] CGPointValue];
        CGPoint leftCheek = [[facePoints objectAtIndex:LeftCheek] CGPointValue];
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

- (CGPoint)getChinCentre {
    CGPoint startPoint = self.chin.elementPoints.firstObject.CGPointValue;
    CGPoint endPoint = self.chin.elementPoints.lastObject.CGPointValue;
    CGPoint topChinCentre = [self getCenterBtwFirstPoint:startPoint andSecondPoint:endPoint];
    CGPoint bottomChinCentre = self.chin.centre;
    
    return [self getCenterBtwFirstPoint:topChinCentre andSecondPoint:bottomChinCentre];
}

- (CGFloat)getChinWidth {
    return self.chin.elementPoints.lastObject.CGPointValue.x - self.chin.elementPoints.firstObject.CGPointValue.x;
}

- (CGFloat)getChinHeight {
    CGPoint startPoint = self.chin.elementPoints.firstObject.CGPointValue;
    CGPoint endPoint = self.chin.elementPoints.lastObject.CGPointValue;
    CGPoint topChinCentre = [self getCenterBtwFirstPoint:startPoint andSecondPoint:endPoint];
    
    // Distance between top centre point of chin and bottom centre point of chin
    CGFloat chinHeight =  self.chin.centre.y - topChinCentre.y;
    
    return chinHeight;
}

- (CGFloat)calculateSmile {
    CGPoint point48 = self.allPointsFromOpenCV[48].CGPointValue;
    CGPoint point54 = self.allPointsFromOpenCV[54].CGPointValue;
    
    CGPoint point61 = self.allPointsFromOpenCV[61].CGPointValue;
    CGPoint point67 = self.allPointsFromOpenCV[67].CGPointValue;
    
    CGPoint point62 = self.allPointsFromOpenCV[62].CGPointValue;
    CGPoint point66 = self.allPointsFromOpenCV[66].CGPointValue;
    
    CGPoint point63 = self.allPointsFromOpenCV[63].CGPointValue;
    CGPoint point65 = self.allPointsFromOpenCV[65].CGPointValue;
    
    CGFloat numerator = [self getLengthBtwFirstPoint:point61 andSecondPoint:point67] + [self getLengthBtwFirstPoint:point62 andSecondPoint:point66] + [self getLengthBtwFirstPoint:point63 andSecondPoint:point65];
    
    CGFloat denominator = [self getLengthBtwFirstPoint:point48 andSecondPoint:point54] * 3;
    
    return numerator / denominator;
}

- (void)addLipsFakePoint {
    // calculate fake points for left lip's corner
    CGPoint point63 = self.allPointsFromOpenCV[63].CGPointValue;
    CGPoint point65 = self.allPointsFromOpenCV[65].CGPointValue;
    CGPoint point64 = self.allPointsFromOpenCV[64].CGPointValue;
    
    CGPoint point70 = CGPointMake((point64.x - point63.x) * 0.85f + point63.x, (point64.y - point63.y) * 0.85f + point63.y);
    CGPoint point71 = CGPointMake((point64.x - point65.x) * 0.85f + point65.x, (point64.y - point65.y) * 0.85f + point65.y);
    
    // calculate fake points for right lip's corner
    CGPoint point61 = self.allPointsFromOpenCV[61].CGPointValue;
    CGPoint point67 = self.allPointsFromOpenCV[67].CGPointValue;
    CGPoint point60 = self.allPointsFromOpenCV[60].CGPointValue;
    
    CGPoint point68 = CGPointMake((point61.x - point60.x) * 0.15f + point60.x, (point61.y - point60.y) * 0.15f + point60.y);
    CGPoint point69 = CGPointMake((point67.x - point60.x) * 0.15f + point60.x, (point67.y - point60.y) * 0.15f + point60.y);
    
    NSArray<NSValue *> *arrayToAdd = @[[NSValue valueWithCGPoint:point68], [NSValue valueWithCGPoint:point69], [NSValue valueWithCGPoint:point70], [NSValue valueWithCGPoint:point71]];
    [self.allPointsFromOpenCV addObjectsFromArray:arrayToAdd];
}


@end
