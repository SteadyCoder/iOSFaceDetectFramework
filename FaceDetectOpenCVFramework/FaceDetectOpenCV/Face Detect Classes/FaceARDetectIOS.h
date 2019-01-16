//
//  FaceARDetectIOS.h
//  FaceAR_SDK_IOS_OpenFace_RunFull
//
//  Created by Keegan Ren on 7/5/16.
//  Copyright © 2016 Keegan Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <iostream>
#include <fstream>
#include <sstream>

// OpenCV includes
#include <opencv2/videoio/videoio.hpp>  // Video write
#include <opencv2/videoio/videoio_c.h>  // Video write
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

#include "LandmarkCoreIncludes.h"
#include "GazeEstimation.h"
#import <UIKit/UIKit.h>

@interface FaceARDetectIOS : NSObject

- (NSMutableArray *)run_FaceAR:(cv::Mat)captured_image frame__:(int)frame_count fx__:(double)fx fy__:(double)fy cx__:(double)cx cy__:(double)cy;

- (BOOL)reset_FaceAR;

- (BOOL)clear_FaceAR;

@end

