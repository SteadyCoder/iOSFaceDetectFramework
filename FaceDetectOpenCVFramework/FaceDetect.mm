//
//  TestClass.m
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/15/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceDetect.h"
#import "FaceDetectOpenCV/Face Detect Classes/FacePoints.h"

#import <opencv2/imgcodecs/ios.h>
#import "FaceDetectOpenCV/Face Detect Classes/FaceARDetectIOS.h"
#import "PhotoCrop.h"

#import "FaceElement.h"
#import "FaceDetectOpenCV/Face Detect Classes/FacePoints.h"

@interface FaceDetect()

@property (nonatomic, readonly, strong) FaceARDetectIOS *faceDetectManager;
@property (nonatomic) int frameCount;

@property (nonatomic) CGFloat rectWidth;
@property (nonatomic) CGFloat rectHeight;

@end

@implementation FaceDetect

- (instancetype)init
{
    self = [super init];
    if (self) {
        _faceDetectManager = [[FaceARDetectIOS alloc] init];
        _rectWidth = 5.0;
        _rectHeight = 5.0;
    }
    return self;
}

- (nullable UIImage *)faceDetectImage:(nonnull UIImage *)imageToDetect {
    return [self faceDetectImage:imageToDetect drawLandmarkAndOtherParametrs:NO];
}

- (nullable UIImage *)faceDetectImage:(nonnull UIImage *)imageToDetect drawLandmarkAndOtherParametrs:(BOOL)draw  {
    self.imageToApplyFaceDetect = imageToDetect;
    cv::Mat matrixFromImage = [self imageToOpenCv];
    
    if (!matrixFromImage.empty()) {
        float fx, fy, cx, cy;
        cx = 1.0 * matrixFromImage.cols / 2.0;
        cy = 1.0 * matrixFromImage.rows / 2.0;
        
        fx = 500 * (matrixFromImage.cols / 640.0);
        fy = 500 * (matrixFromImage.rows / 480.0);
        
        fx = (fx + fy) / 2.0;
        fy = fx;
        
        NSMutableArray *facePoints = [self.faceDetectManager run_FaceAR:matrixFromImage frame__:self.frameCount fx__:fx fy__:fy cx__:cx cy__:cy];
        if (facePoints) {
            self.landmarkPoints = [[FacePoints alloc] initWithFaceDetectedPoints:facePoints];
            
            [self drawLandmarksOnImage:self.landmarkPoints drawLandmarkAndOtherParametrs:draw];
        }
        self.frameCount = self.frameCount + 1;
    }
    return self.resultImage;
}

- (void)drawLandmarksOnImage:(FacePoints *)landmarkPoints drawLandmarkAndOtherParametrs:(BOOL)draw {
    if (landmarkPoints.allPointsFromOpenCV) {
        self.resultImage = [self.imageToApplyFaceDetect copy];
        
        UIGraphicsBeginImageContext(self.imageToApplyFaceDetect.size);
        
        [self.resultImage drawAtPoint:CGPointZero];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (draw) {
            [self drawLandmarksAndOtherParametersWithContext:context];
        }
        
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        self.resultImage = finalImage;
    }
}

- (void)drawLandmarksAndOtherParametersWithContext:(CGContextRef)context {
    [[UIColor yellowColor] setStroke];
    
    // ********************************** Draw face points
    [self drawPointsWithLandmarkPointArray:self.landmarkPoints.chinPoints withContext:context];
    
    [self drawPointsWithLandmarkPointArray:self.landmarkPoints.leftEyebrowPoints withContext:context];
    [self drawPointsWithLandmarkPointArray:self.landmarkPoints.rightEyebrowPoints withContext:context];
    
    [self drawPointsWithLandmarkPointArray:self.landmarkPoints.nosePoints withContext:context];
    
    [self drawPointsWithLandmarkPointArray:self.landmarkPoints.leftEyePoints withContext:context];
    [self drawPointsWithLandmarkPointArray:self.landmarkPoints.rightEyePoints withContext:context];
    
    [self drawPointsWithLandmarkPointArray:self.landmarkPoints.mouthPoints withContext:context];
    
    NSValue *noseCentre = [NSValue valueWithCGPoint:CGPointMake(self.landmarkPoints.noseCenterPoint.x, self.landmarkPoints.noseCenterPoint.y)];
    
    [[UIColor redColor] setStroke];
    [self drawPointsWithLandmarkPointArray:@[noseCentre] withContext:context];
    
    // **********************************
    // ********************************** Draw opencv bounding rect
    CGContextAddRect(context, self.faceDetectManager.boundingBox);
    CGContextStrokeRect(context, self.faceDetectManager.boundingBox);
    
    // **********************************
    // ********************************** Centre eyes
    
    [[UIColor greenColor] setStroke];
    NSValue *centreBetweenEyes = [NSValue valueWithCGPoint:self.landmarkPoints.centerBetweenEyesPoint];
    [self drawPointsWithLandmarkPointArray:@[centreBetweenEyes] withContext:context];
    // **********************************
}

- (void)cropExtraAreasOnResultImage {
    self.resultImage = [PhotoCrop facePhotoCrop:self.landmarkPoints photoToCrop:self.resultImage];
}

- (void)drawPointsWithLandmarkPointArray:(NSArray<NSValue *> *)elementLandmarkPoints withContext:(CGContextRef)context {
    int i = 0;
    while (i < elementLandmarkPoints.count) {
        CGPoint point = elementLandmarkPoints[i].CGPointValue;
        
        CGFloat width = self.rectWidth;
        CGFloat height = self.rectHeight;
        
        // make circle rect 5 px from border
        CGRect circleRect = CGRectMake(point.x - width / 2, point.y - height / 2, width, height);
        
        // draw circle
        CGContextStrokeEllipseInRect(context, circleRect);
        i++;
    }
}


- (cv::Mat)imageToOpenCv {
    cv::Mat cvImage;
    UIImageToMat(self.imageToApplyFaceDetect, cvImage);
    
    cv::Mat targetImage(cvImage.cols, cvImage.rows, CV_8UC3);
    cv::cvtColor(cvImage, targetImage, cv::COLOR_BGRA2BGR);
    
    return targetImage;
}



@end


