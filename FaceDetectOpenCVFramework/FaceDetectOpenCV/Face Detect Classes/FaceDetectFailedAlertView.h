//
//  FaceDetectFailedAlertView.h
//  Halogram
//
//  Created by Alexandr Polukhin on 11/8/18.
//  Copyright © 2018 krestone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceDetectFailedAlertView : UIView

@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UILabel *ooopsLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

