//
//  UIViewController+PresentInWindow.m
//  TCTravel_IPhone
//
//  Created by Yimin Huang on 15/5/25.
//
//

#import "UIViewController+PresentInWindow.h"

@implementation UIViewController (PresentInWindow)

- (void)xx_presentInWindow {
    
    self.view.alpha = 0;
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.view];
    
    NSDictionary *dic = @{@"_view_": self.view};
    [keyWindow addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_view_]|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:dic]];
    [keyWindow addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_view_]|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:dic]];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0f;
    }];
}

- (void)xx_dismissWithAnimation:(BOOL)animation {
    if (!animation) {
        [self.view removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

@end
