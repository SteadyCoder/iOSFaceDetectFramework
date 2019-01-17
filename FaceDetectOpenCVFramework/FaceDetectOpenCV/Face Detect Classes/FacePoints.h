//
//  FacePoints.h
//  Halogram
//
//  Created by Ira on 02.04.18.
//  Copyright © 2018 krestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>

@class FaceElement, ChinElement, MouthElement;

@interface FacePoints : NSObject

@property (nonatomic, strong) FaceElement *leftEye;
@property (nonatomic, strong) FaceElement *rightEye;
@property (nonatomic, strong) FaceElement *leftEyeBrow;
@property (nonatomic, strong) FaceElement *rightEyeBrow;
@property (nonatomic, strong) FaceElement *nose;
@property (nonatomic, strong) MouthElement *mouth;
@property (nonatomic, strong) ChinElement *chin;


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
