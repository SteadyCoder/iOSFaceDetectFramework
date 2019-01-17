//
//  PhotoCrop.m
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/17/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import "PhotoCrop.h"
#import "Custom Categories/UIImage+Crop.h"
#import "FaceDetectOpenCV/Face Detect Classes/FacePoints.h"
#import "FaceDetectOpenCV/Face Detect Classes/FaceElement.h"

@implementation PhotoCrop

+ (UIImage *)facePhotoCrop:(FacePoints *)facePoints photoToCrop:(UIImage *)photoToCrop {
    CGFloat width = photoToCrop.size.width;
    CGFloat height = photoToCrop.size.height;
    
    CGPoint eyesCentre = facePoints.centerBetweenEyesPoint;
    
    CGPoint mouthCentre = facePoints.mouth.centre;
    
    CGFloat percentBetweenMouthAndEyes = 0.2705;
    CGFloat percentBetweenEyeAndTop = 0.43;
    CGFloat percBetwMouthAndBottom = 1 - percentBetweenMouthAndEyes - percentBetweenEyeAndTop;
    
    //proportion: if distance between mouth and eyes = percBetwMouthAndEyes (%), then texture size = 1 (100%)
    CGFloat textureProportion = (mouthCentre.y - eyesCentre.y) / percentBetweenMouthAndEyes;
    
    NSInteger dTop = (NSInteger) (eyesCentre.y - textureProportion * percentBetweenEyeAndTop);
    NSInteger dLeft = (NSInteger) (eyesCentre.x - textureProportion * 0.5);
    NSInteger dBottom = (NSInteger) ((height - mouthCentre.y) - textureProportion * percBetwMouthAndBottom);
    NSInteger dRight = (NSInteger) ((width - eyesCentre.x) - textureProportion * 0.5);
    
    //if dX is positive, we are cutting this side of image
    //todo: experimental decision to cut less of image. Maybe remove it
    if (dTop > 0 && dRight > 0 && dBottom > 0 && dLeft > 0) {
        NSUInteger compensationForCutting = MIN(dTop, MIN(dRight, MIN(dBottom, dLeft)));
        
        dTop -= compensationForCutting;
        dRight -= compensationForCutting;
        dBottom -= compensationForCutting;
        dLeft -= compensationForCutting;
    }
    
    CGRect cropRect = CGRectMake(MAX(dLeft, 0), MAX(dTop, 0), width - MAX(dRight, 0) - MAX(dLeft, 0), height - MAX(dBottom, 0) - MAX(dTop, 0));
    
    
    UIImage *finalImage = [photoToCrop crop:cropRect];
    
    return finalImage;
}

@end
