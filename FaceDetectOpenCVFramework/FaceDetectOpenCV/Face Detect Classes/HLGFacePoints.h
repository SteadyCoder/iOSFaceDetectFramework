//
//  HLGFacePoints.h
//  Halogram
//
//  Created by Ira on 02.04.18.
//  Copyright © 2018 krestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>

@class HLGFaceElement, HLGChinElement, HLGMouthElement;

@interface HLGFacePoints : NSObject

@property (nonatomic, strong) HLGFaceElement *leftEye;
@property (nonatomic, strong) HLGFaceElement *rightEye;
@property (nonatomic, strong) HLGFaceElement *leftEyeBrow;
@property (nonatomic, strong) HLGFaceElement *rightEyeBrow;
@property (nonatomic, strong) HLGFaceElement *nose;
@property (nonatomic, strong) HLGMouthElement *mouth;
@property (nonatomic, strong) HLGChinElement *chin;


/**
 All points from openCV
 */
@property (nonatomic) NSMutableArray<NSValue *> *allPointsFromOpenCV;

/**
 @attention
 Right eye means right from how do we look at the photo
 */
@property (nonatomic, readonly) NSArray<NSValue *> *rightEyePoints;

/**
 @attention
 Left eye means left from how do we look at the photo
 */
@property (nonatomic, readonly) NSArray<NSValue *> *leftEyePoints;

/**
 @attention
 Right eyebrow means right from how do we look at the photo
 */
@property (nonatomic, readonly) NSArray<NSValue *> *rightEyebrowPoints;

/**
 @attention
 Left eyebrow means left from how do we look at the photo
 */
@property (nonatomic, readonly) NSArray<NSValue *> *leftEyebrowPoints;

@property (nonatomic, readonly) NSArray<NSValue *> *nosePoints;
@property (nonatomic, readonly) NSArray<NSValue *> *mouthPoints;
@property (nonatomic, readonly) NSArray<NSValue *> *chinPoints;

@property (nonatomic, readonly) CGPoint noseCenterPoint;
@property (nonatomic, readonly) CGPoint mouthCenterPoint;
@property (nonatomic, readonly) CGPoint chinCenterPoint;
@property (nonatomic, readonly) CGPoint centerBetweenEyesPoint;
@property (nonatomic, readonly) CGPoint leftEyeCenterPoint;
@property (nonatomic, readonly) CGPoint rightEyeCenterPoint;

//Points need for detect color of eyes
@property (nonatomic, readonly) CGPoint rightEyeTop;
@property (nonatomic, readonly) CGPoint rightEyeDown;

@property (nonatomic, readonly) CGFloat angleOfHead;

- (instancetype)initWithFaceDetectedPoints:(NSMutableArray<NSValue *> *)facePoints NS_DESIGNATED_INITIALIZER;

@end
