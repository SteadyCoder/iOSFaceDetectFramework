//
//  FaceDetectFailedAlertView.m
//  Halogram
//
//  Created by Alexandr Polukhin on 11/8/18.
//  Copyright © 2018 krestone. All rights reserved.
//

#import "FaceDetectFailedAlertView.h"

@implementation FaceDetectFailedAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Localized string
    NSString *firstLineDescription = NSLocalizedString(@"Your face was not detected automatically", nil);
    NSString *secondLineDesciption = NSLocalizedString(@"\nWould you like to process it manually?", nil);
    
    NSString *noButtonText = NSLocalizedString(@"No", nil);
    NSString *yesButtonText = NSLocalizedString(@"Yes", nil);
    
    // Attributing localized string
    NSMutableAttributedString *attributedFirstLine = [[NSMutableAttributedString alloc] initWithString:firstLineDescription attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:17.0]}];
    
    NSAttributedString *attributedSecondLine = [[NSAttributedString alloc] initWithString:secondLineDesciption attributes:
    @{NSFontAttributeName: [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithFontAttributes:
                                                    @{UIFontDescriptorFamilyAttribute: @"Arial",
                                                      UIFontDescriptorTraitsAttribute: @{UIFontWeightTrait: @(UIFontWeightBold)}}] size:17.0]}];
    [attributedFirstLine appendAttributedString:attributedSecondLine];
    
    NSAttributedString *yesAttributedText = [[NSAttributedString alloc] initWithString:yesButtonText];
    NSAttributedString *noAttributedText = [[NSAttributedString alloc] initWithString:noButtonText attributes:
                                            @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    
    // Set up of attributed string in UI
    self.descriptionLabel.attributedText = attributedFirstLine;
    [self.noButton setAttributedTitle:noAttributedText forState:UIControlStateNormal];
    [self.yesButton setAttributedTitle:yesAttributedText forState:UIControlStateNormal];
}

@end
