//
//  CompanyAnnotationView.m
//  MACAddressInfo
//
//  Created by hadlinks on 2019/10/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "CompanyAnnotationView.h"

NSString *const CompanyAnnotationID = @"CompanyAnnotationIdentifier";

@implementation CompanyAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        self.image = [UIImage imageNamed:@"location_annotation_icon"];
        self.canShowCallout = YES;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)prepareForDisplay {
    [super prepareForDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
