//
//  HLGFaceElement.h
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/16/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLGFaceElement : NSObject

- (instancetype)initWithPoints:(NSArray<NSValue *> *)points;

@property (nonatomic, readonly, strong) NSArray<NSValue *> *elementPoints;

@property (nonatomic, readwrite) CGFloat width;
@property (nonatomic, readwrite) CGFloat height;
@property (nonatomic, readwrite) CGPoint position;
@property (nonatomic, readwrite) CGPoint centre;

@end

@interface HLGChinElement : HLGFaceElement

@property (nonatomic, readwrite) CGPoint topCentre;
@property (nonatomic, readwrite) CGPoint bottomCentre;

@end

@interface HLGMouthElement : HLGFaceElement

@property (nonatomic, readwrite) CGPoint leftCorner;
@property (nonatomic, readwrite) CGPoint rightCorner;

@end

NS_ASSUME_NONNULL_END
