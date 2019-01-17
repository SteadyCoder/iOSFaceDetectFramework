//
//  PhotoCrop.h
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/17/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLGFacePoints;

@interface PhotoCrop : NSObject

+ (UIImage *)facePhotoCrop:(HLGFacePoints *)facePoints photoToCrop:(UIImage *)photoToCrop;

@end

NS_ASSUME_NONNULL_END
