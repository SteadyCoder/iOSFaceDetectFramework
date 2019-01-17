//
//  TestClass.m
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/15/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceDetect.h"
#import "FaceDetectOpenCV/Face Detect Classes/HLGFacePoints.h"

#import <opencv2/imgcodecs/ios.h>
#import "FaceDetectOpenCV/Face Detect Classes/FaceARDetectIOS.h"
#import "PhotoCrop.h"

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

- (UIImage *)faceDetectImage:(UIImage *)imageToDetect {
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
            self.landmarkPoints = [[HLGFacePoints alloc] initWithFaceDetectedPoints:facePoints];
            
            [self drawLandmarksOnImage:self.landmarkPoints];
        }
        self.frameCount = self.frameCount + 1;
    }
    return self.resultImage;
}

- (void)drawLandmarksOnImage:(HLGFacePoints *)landmarkPoints {
    if (landmarkPoints.allPointsFromOpenCV) {
        self.resultImage = [self.imageToApplyFaceDetect copy];
        
        UIGraphicsBeginImageContext(self.imageToApplyFaceDetect.size);
        
        [self.resultImage drawAtPoint:CGPointZero];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [[UIColor yellowColor] setStroke];
        
//        [self drawPointsWithLandmarkPointArray:self.landmarkPoints.allPointsFromOpenCV withContext:context];
        // ********************************** Draw face points
        [self drawPointsWithLandmarkPointArray:landmarkPoints.chinPoints withContext:context];

        [self drawPointsWithLandmarkPointArray:landmarkPoints.leftEyebrowPoints withContext:context];
        [self drawPointsWithLandmarkPointArray:landmarkPoints.rightEyebrowPoints withContext:context];

        [self drawPointsWithLandmarkPointArray:landmarkPoints.nosePoints withContext:context];

        [self drawPointsWithLandmarkPointArray:landmarkPoints.leftEyePoints withContext:context];
        [self drawPointsWithLandmarkPointArray:landmarkPoints.rightEyePoints withContext:context];

        [self drawPointsWithLandmarkPointArray:landmarkPoints.mouthPoints withContext:context];
        
        NSValue *noseCentre = [NSValue valueWithCGPoint:CGPointMake(landmarkPoints.noseCenterPoint.x, landmarkPoints.noseCenterPoint.y)];
        
        [[UIColor redColor] setStroke];
        [self drawPointsWithLandmarkPointArray:@[noseCentre] withContext:context];
        
        NSValue *topPoint = [NSValue valueWithCGPoint:CGPointMake(self.landmarkPoints.chin.centre.x, self.landmarkPoints.chin.centre.y - self.landmarkPoints.chin.height)];
        
        // **********************************
        // ********************************** Draw opencv bounding rect
        
        CGRect changedRect = self.faceDetectManager.boundingBox;
        NSLog(@"Bounding rect %@", NSStringFromCGRect(self.faceDetectManager.boundingBox));
        changedRect.size.height *= 1.25;
        changedRect.size.width *= 1.25;
        NSLog(@"Bounding rect2 %@", NSStringFromCGRect(changedRect));
        
        CGContextAddRect(context, self.faceDetectManager.boundingBox);
        CGContextStrokeRect(context, self.faceDetectManager.boundingBox);
        
        // **********************************
        // ********************************** Centre eyes
        
        [[UIColor greenColor] setStroke];
        NSValue *centreBetweenEyes = [NSValue valueWithCGPoint:self.landmarkPoints.centerBetweenEyesPoint];
        [self drawPointsWithLandmarkPointArray:@[centreBetweenEyes] withContext:context];
        
        // **********************************
        
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        finalImage = [PhotoCrop facePhotoCrop:self.landmarkPoints photoToCrop:finalImage];
        
        UIGraphicsEndImageContext();
        
        self.resultImage = finalImage;
    }
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


