//
//  TestClass.h
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/15/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#ifndef TestClass_h
#define TestClass_h

#import <UIKit/UIKit.h>

@class FacePoints;

@interface FaceDetect : NSObject

@property (nonatomic, readwrite, strong, nullable) UIImage *imageToApplyFaceDetect;
@property (nonatomic, readwrite, strong, nullable) UIImage *resultImage;
@property (nonatomic, readwrite, strong, nullable) FacePoints *landmarkPoints;

- (nullable UIImage *)faceDetectImage:(nonnull UIImage *)imageToDetect;
- (nullable UIImage *)faceDetectImage:(nonnull UIImage *)imageToDetect drawLandmarkAndOtherParametrs:(BOOL)draw;
- (void)cropExtraAreasOnResultImage;

@end

#endif /* TestClass_h */
