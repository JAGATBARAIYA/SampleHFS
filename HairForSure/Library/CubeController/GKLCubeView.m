//
//  GKLViewController.m
//  CubeViewController
//
//  Created by Joseph Pintozzi on 11/28/12.
//  Copyright (c) 2012 GoKart Labs. All rights reserved.
//

#import "GKLCubeView.h"

CGFloat const kPerspective = -0.001f;
CGFloat const kDuration    =  0.2f;

@interface GKLCubeView ()

// basic cube state properties

@property (nonatomic)         NSInteger       facingSide;

// basic CADisplayLink properties

@property (nonatomic, strong) CADisplayLink  *displayLink;
@property (nonatomic)         CFTimeInterval  startTime;

// display link state properties

@property (nonatomic)         CFTimeInterval  animationDuration;
@property (nonatomic)         CGFloat         startAngle;
@property (nonatomic)         CGFloat         targetAngle;

@end


@implementation GKLCubeView

- (instancetype)initWithFrame:(CGRect)frame views:(NSArray *)arrViews {
    if(self == [super initWithFrame:frame]) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
        
        self.facingSide = 0;
        self.arrViews = [arrViews mutableCopy];
        [self.arrViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {

            view.frame = self.bounds;
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addSubview:view];
            view.alpha = 0.0;
            
            if(idx == 0) {
                _visibleView = view;
                [view setAlpha:1.0];
            }
        }];
    }
    return self;
}

#pragma mark - Management of cube sides

- (void)rotateCubeSideForView:(UIView *)view byAngle:(CGFloat)angle applyPerspective:(BOOL)applyPerspective
{
    while (angle > M_PI) angle -= (M_PI * 2.0);

    if (angle <= -M_PI_2 || angle >= M_PI_2)
    {
        if (view.alpha != 0.0)
        {
            view.alpha = 0.0;
        }
        return;
    }

    double halfWidth = self.bounds.size.width / 2.0;
    CGFloat perspective = kPerspective;
    CATransform3D transform = CATransform3DIdentity;
    if (applyPerspective) transform.m34 = perspective;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform, angle, 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    view.layer.transform = transform;

    if (view.alpha == 0.0)
    {
        view.alpha = 1.0;
        view.frame = view.superview.bounds;
    }
}

- (void)rotateAllSidesBy:(double)rotation
{
    [_arrViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGFloat startingAngle = ((idx + _facingSide) % 4) * M_PI_2;
        [self rotateCubeSideForView:view byAngle:startingAngle+rotation applyPerspective:YES];
    }];
}

#pragma mark - Gesture Recognizer

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    double percentageOfWidth = translation.x / self.frame.size.width;

    double rotation = percentageOfWidth * M_PI_2;
    
    NSInteger indexOfVisibleView = [_arrViews indexOfObject:_visibleView];
    if((rotation > 0 && indexOfVisibleView == 0) ||
       (rotation < 0 && indexOfVisibleView == [_arrViews count] - 1)) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged)
    {
        
        [self rotateAllSidesBy:rotation];
    }

    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint velocity = [gesture velocityInView:gesture.view];

        // factor in velocity to capture a "flick"

        double percentageOfWidthIncludingVelocity = (translation.x + 0.25 * velocity.x) / self.frame.size.width;

        self.startAngle = percentageOfWidth * M_PI_2;

        // if moved left (and/or flicked left)
        if (translation.x < 0 && percentageOfWidthIncludingVelocity < -0.5)
            self.targetAngle = -M_PI_2;

        // if moved right (and/or flicked right)
        else if (translation.x > 0 && percentageOfWidthIncludingVelocity > 0.5)
            self.targetAngle = M_PI_2;

        // otherwise, move back to zero
        else
            self.targetAngle = 0.0;

        [self startDisplayLink];
    }
}

#pragma mark - CADisplayLink

/*
 Using display link is probably overkill here, but it

 (a) keeps the sides of the cube synchronized during rotation;
 (b) avoids the performance hit of putting transformed sides of a cube within a layer/view with its own transform

 The end result should be a more responsive rotation animation. The downside is that I'm employing a simplistic linear animation.
 */

- (void)startDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    self.startTime = CACurrentMediaTime();
    self.animationDuration = fabs(self.targetAngle - self.startAngle) / M_PI_2 * kDuration;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    CFTimeInterval elapsed = CACurrentMediaTime() - self.startTime;
    CGFloat percentComplete = (elapsed / self.animationDuration);

    if (percentComplete >= 0.0 && percentComplete < 1.0)
    {
        // if animation is still in progress, then update to show progress

        CGFloat rotation = (self.targetAngle - self.startAngle) * percentComplete + self.startAngle;
        
        [self rotateAllSidesBy:rotation];
    }
    else
    {
        // we are done

        [self stopDisplayLink];

        CGFloat faceAdjustment = self.targetAngle / M_PI_2;
        self.facingSide = (int)floorf(faceAdjustment + self.facingSide + 4.5) % 4;

        [self rotateAllSidesBy:0.0];
        
        [_arrViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if(view.alpha == 1.0) {
                _visibleView = view;
                if ([_delegate respondsToSelector:@selector(cubeViewDidShowAtIndex:)])
                    [_delegate cubeViewDidShowAtIndex:idx];
                *stop = YES;
                
            }
        }];
    }
}

@end
