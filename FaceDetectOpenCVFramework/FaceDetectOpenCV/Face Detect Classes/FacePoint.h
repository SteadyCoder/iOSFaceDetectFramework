//
//  FacePoint.h
//  FaceDetectOpenCVFramework
//
//  Created by Ivan on 1/18/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FacePoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat z;

- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y;
- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y andZ:(CGFloat)z;
- (instancetype)initWithArray:(NSArray *)pointArray;

+ (instancetype)facePointWithX:(CGFloat)x andY:(CGFloat)y;
+ (instancetype)facePointWithX:(CGFloat)x andY:(CGFloat)y andZ:(CGFloat)z;

+ (instancetype)nullPoint;

- (CGPoint)cgPoint;

@end

NS_ASSUME_NONNULL_END
