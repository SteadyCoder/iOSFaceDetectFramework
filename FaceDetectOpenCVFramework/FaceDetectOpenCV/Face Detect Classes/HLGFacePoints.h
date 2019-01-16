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

@class HLGFaceElement;

@interface HLGFacePoints : NSObject

@property (nonatomic, strong) HLGFaceElement *leftEye;
@property (nonatomic, strong) HLGFaceElement *rightEye;
@property (nonatomic, strong) HLGFaceElement *leftEyeBrow;
@property (nonatomic, strong) HLGFaceElement *rightEyeBrow;
@property (nonatomic, strong) HLGFaceElement *nose;
@property (nonatomic, strong) HLGFaceElement *mouth;
@property (nonatomic, strong) HLGFaceElement *chin;


/**
 All points from openCV
 */
@property (nonatomic) NSMutableArray<NSValue *> *allPointsFromOpenCV;

/**
 @attention
 Right eye means right from how do we look at the photo
 */
@property (nonatomic, readonly) NSArray *rightEyePoints;

/**
 @attention
 Left eye means left from how do we look at the photo
 */
@property (nonatomic, readonly) NSArray *leftEyePoints;

/**
 @attention
 Right eyebrow means right from how do we look at the photo
 */
@property (nonatomic, readonly) NSArray *rightEyebrowPoints;

/**
 @attention
 Left eyebrow means left from how do we look at the photo
 */
@property (nonatomic, readonly) NSArray *leftEyebrowPoints;

@property (nonatomic, readonly) NSArray *nosePoints;
@property (nonatomic, readonly) NSArray *mouthPoints;
@property (nonatomic, readonly) NSArray *chinPoints;

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

- (instancetype)initWithFaceDetectedPoints:(NSMutableArray *)facePoints NS_DESIGNATED_INITIALIZER;

@end
