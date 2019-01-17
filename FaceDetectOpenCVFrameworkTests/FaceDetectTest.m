//
//  FaceDetectTest.m
//  FaceDetectOpenCVFrameworkTests
//
//  Created by Ivan on 1/16/19.
//  Copyright © 2019 krestone. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../FaceDetectOpenCVFramework/FaceDetect.h"

@interface FaceDetectTest : XCTestCase

@property (nonatomic, strong) FaceDetect *testClass;

@end

@implementation FaceDetectTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testClass = [[FaceDetect alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    UIImage *testImage = [UIImage imageNamed:@"testFace3" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    UIImage *testImage1 = [UIImage imageNamed:@"testFace4" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    UIImage *testImage2 = [UIImage imageNamed:@"testFace2" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    UIImage *testImage6 = [UIImage imageNamed:@"testFace6" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    
    UIImage *resultImage = [self.testClass faceDetectImage:testImage drawLandmarkAndOtherParametrs:YES];
    UIImage *resultImage1 = [self.testClass faceDetectImage:testImage1];
    UIImage *resultImage2 = [self.testClass faceDetectImage:testImage2 drawLandmarkAndOtherParametrs:YES];
    [self.testClass faceDetectImage:testImage6];
    [self.testClass cropExtraAreasOnResultImage];
    UIImage *resultImage6 = self.testClass.resultImage;
    
     if (resultImage != nil) {
        NSLog(@"Face landamrks detected");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
