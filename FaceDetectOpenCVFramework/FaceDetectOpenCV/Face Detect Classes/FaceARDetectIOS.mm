//
//  FaceARDetectIOS.m
//  FaceAR_SDK_IOS_OpenFace_RunFull
//
//  Created by Keegan Ren on 7/5/16.
//  Copyright © 2016 Keegan Ren. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "FaceARDetectIOS.h"

LandmarkDetector::FaceModelParameters det_parameters;
// The modules that are being used for tracking
LandmarkDetector::CLNF clnf_model;

@interface FaceARDetectIOS ()

@end

@implementation FaceARDetectIOS

//bool inits_FaceAR();
- (instancetype)init {
    self = [super init];
    NSBundle *frameworkBundle = [NSBundle bundleForClass:self.class];
    
    NSString *modelClnfPath = [[NSString stringWithFormat:@"model"] stringByAppendingPathComponent:@"main_clnf_general.txt"];
    NSString *faceDetectorPath = [[NSString stringWithFormat:@"classifiers"] stringByAppendingPathComponent:@"haarcascade_frontalface_alt.xml"];
    
    const char *modelLocation = [frameworkBundle pathForResource:modelClnfPath ofType:nil].UTF8String;
    const char *faceDetectorLocation = [frameworkBundle pathForResource:faceDetectorPath ofType:nil].UTF8String;
    det_parameters.init();
    det_parameters.model_location = modelLocation;
    det_parameters.face_detector_location = faceDetectorLocation;
    
    clnf_model.model_location_clnf = modelLocation;
    clnf_model.face_detector_location_clnf = faceDetectorLocation;
    clnf_model.inits();
    
    return self;
}

//bool run_FaceAR(cv::Mat &captured_image, int frame_count, float fx, float fy, float cx, float cy);
- (NSMutableArray *)run_FaceAR:(cv::Mat) captured_image frame__:(int)frame_count fx__:(double)fx fy__:(double)fy cx__:(double)cx cy__:(double)cy {
    // Reading the images
    cv::Mat_<float> depth_image;
    cv::Mat_<uchar> grayscale_image;
    NSMutableArray *neededPointsForCapturingImage;
    
    if(captured_image.channels() == 3)
    {
        cv::cvtColor(captured_image, grayscale_image, CV_BGR2GRAY);
    }
    else
    {
        grayscale_image = captured_image.clone();
    }
    
    // The actual facial landmark detection / tracking
    bool detection_success = LandmarkDetector::DetectLandmarksInImage(grayscale_image, depth_image, clnf_model, det_parameters);
    
    if(detection_success) {
        neededPointsForCapturingImage = [self getNeededLandmarksWithFaceModel:clnf_model];
    } else {
        neededPointsForCapturingImage = nil;
    }
    return neededPointsForCapturingImage;
}

- (NSMutableArray *)getNeededLandmarksWithFaceModel:(const LandmarkDetector::CLNF)face_model {
    
    double detection_certainty = face_model.detection_certainty;
    
    int idx = clnf_model.patch_experts.GetViewIdx(clnf_model.params_global, 0);
    
    const cv::Mat_<int>& visibilities = clnf_model.patch_experts.visibilities[0][idx];
    
    double visualisation_boundary = 0.2;
    
    NSMutableArray *facePoints = [[NSMutableArray alloc] init];
    
    // Only draw if the reliability is reasonable, the value is slightly ad-hoc
    if (detection_certainty < visualisation_boundary) {
        int n = clnf_model.detected_landmarks.rows / 2;
        if(n >= 66)
        {
            for (int i = 0;i<n;i++) {
                if (visibilities.at<int>(i))
                {
                    cv::Point featurePoint((int)clnf_model.detected_landmarks.at<double>(i),
                                           (int)clnf_model.detected_landmarks.at<double>(i +n));
                    cv::Rect boundingBox = clnf_model.GetBoundingBox();
                    self.boundingBox = CGRectMake(boundingBox.x, boundingBox.y, boundingBox.size().width, boundingBox.size().height);
                    CGPoint featureCGpoint = CGPointMake(featurePoint.x, featurePoint.y);
                    [facePoints addObject:[NSValue valueWithCGPoint:featureCGpoint]];
                }
            }
        }
    }
    return facePoints;
}

//bool reset_FaceAR();
- (BOOL)reset_FaceAR {
    clnf_model.Reset();
    
    return true;
}

//bool clear_FaceAR();
- (BOOL)clear_FaceAR {
    clnf_model.Reset();
    
    return true;
}


@end

