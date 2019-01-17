//
//  UIImage+Crop.h
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/17/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Crop)

- (UIImage *)crop:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
