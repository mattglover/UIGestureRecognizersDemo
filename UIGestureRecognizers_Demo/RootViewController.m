//
//  RootViewController.m
//  UIGestureRecognizers_Demo
//
//  Created by Matt Glover on 07/04/2013.
//  Copyright (c) 2013 Duchy Software Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "CMUnistrokeRecognizer.h"
#import "GestureRecognizers.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
  kGestureImageIndexTap = 1,
  kGestureImageIndexSwipe,
  kGestureImageIndexPan,
  kGestureImageIndexPinch,
  kGestureImageIndexRotate,
  kGestureImageIndexLongPress
}  GestureImageIndex;

#define DEFAULT_ANIMATION_DURATION 0.4

@interface RootViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, assign) CGPoint touchOffsetFromCenterOfPanningImageView;
@end

@implementation RootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    path = [UIBezierPath bezierPath];
  
  [self.view setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0]];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self setupImageViews:@[[UIImage imageNamed:@"tap"],
   [UIImage imageNamed:@"swipe"],
   [UIImage imageNamed:@"pan"],
   [UIImage imageNamed:@"pinch"],
   [UIImage imageNamed:@"rotate"],
   [UIImage imageNamed:@"longPress"]]
   ];
  
  for (UIImageView *imageView in self.imageViews) {
    [self.view addSubview:imageView];
  }
  
  // Taps
  // Display the relevent GestureImage - Depending on the number of 'taps'
  [self setupGesturesForView:self.view];
    
    //Additional Custom Recognizers
    [self addCustomRecognizers];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


#pragma mark - Setup
- (void)setupImageViews:(NSArray *)images {
  
  self.imageViews = [[NSMutableArray alloc] init];
  
  for (int index = 0; index < [images count]; index++) {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:images[index]];
    [imageView setBounds:CGRectMake(0, 0, 150, 150)];
    [imageView setUserInteractionEnabled:YES];
    [imageView setCenter:[self offscreenPosition]];
    [imageView setTag:index+1];
    
    // Gesture
    // Setup Gesture - Depending on the type of View
    [self setupGesturesForView:imageView];
    [self setupLongPressToResetView:imageView];
    
    [self.imageViews addObject:imageView];
  }
}


#pragma mark - Setup UIGestureRecognizers
- (void)setupGesturesForView:(UIView *)view {
  
  switch (view.tag) {
    case 0: // self.view
      
      for (int tapNumber = 1; tapNumber <= [self.imageViews count]; tapNumber++) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGestureImage:)];
        [tapGesture setNumberOfTapsRequired:tapNumber];
        
        for (UIGestureRecognizer *existingGesture in view.gestureRecognizers) {
          [existingGesture requireGestureRecognizerToFail:tapGesture];
        }
        
        [view addGestureRecognizer:tapGesture];
      }
      break;
      
    case kGestureImageIndexSwipe:{
      UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwipedWithGesture:)];
      [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
      [view addGestureRecognizer:swipeGestureLeft];
      
      UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwipedWithGesture:)];
      [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
      [view addGestureRecognizer:swipeGestureRight];
      
      UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwipedWithGesture:)];
      [swipeGestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
      [view addGestureRecognizer:swipeGestureUp];
      
      UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwipedWithGesture:)];
      [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
      [view addGestureRecognizer:swipeGestureDown];
    }
      break;
      
    case kGestureImageIndexPan:{
      UIPanGestureRecognizer *panningGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanningWithGesture:)];
      [view addGestureRecognizer:panningGesture];
    }
      break;
      
    case kGestureImageIndexPinch:{
      UIPinchGestureRecognizer *pinchingGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imagePinchedWithGesture:)];
      [view addGestureRecognizer:pinchingGesture];
    }
      break;
      
    case kGestureImageIndexRotate:{
      UIRotationGestureRecognizer *rotatingGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(imageRotatedWithGesture:)];
      [view addGestureRecognizer:rotatingGesture];
    }
      break;
      
    default:
      break;
  }
}

- (void)setupLongPressToResetView:(UIView *)view {
  
  UILongPressGestureRecognizer *resetLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(resetView:)];
  [view addGestureRecognizer:resetLongPressGesture];
}



#pragma mark - UIGestureRecognizer Listeners
- (void)showGestureImage:(UITapGestureRecognizer *)gesture {
  
  NSUInteger index = [gesture numberOfTapsRequired] -1;
  [self showImageView:self.imageViews[index]];
}

- (void)resetView:(UITapGestureRecognizer *)gesture {
  
  UIView *viewToBeReset = gesture.view;
  [self resetImageView:viewToBeReset];
}

- (void)imageSwipedWithGesture:(UISwipeGestureRecognizer *)gesture {
  
  CGPoint center = gesture.view.center;
  
  switch (gesture.direction) {
    case UISwipeGestureRecognizerDirectionDown:
      center.y = CGRectGetHeight(self.view.bounds) + CGRectGetHeight(self.view.bounds);
      break;
      
    case UISwipeGestureRecognizerDirectionUp:
      center.y = CGRectGetMinY(self.view.frame) - CGRectGetHeight(self.view.bounds);
      break;
      
    case UISwipeGestureRecognizerDirectionLeft:
      center.x = CGRectGetMinX(self.view.frame) - CGRectGetWidth(self.view.bounds);
      break;
      
    case UISwipeGestureRecognizerDirectionRight:
      center.x = CGRectGetWidth(self.view.bounds) + CGRectGetWidth(self.view.bounds);
      break;
      
    default:
      break;
  }
  
  [self moveView:gesture.view offScreenWithCenter:center];
}

- (void)imagePanningWithGesture:(UIPanGestureRecognizer *)gesture {
  
  UIView *view = gesture.view;
  
  switch ([gesture state]) {
      
    case UIGestureRecognizerStateBegan:
      [self.view bringSubviewToFront:gesture.view];
      self.touchOffsetFromCenterOfPanningImageView = CGPointMake(view.center.x - [gesture locationInView:self.view].x,
                                                                 view.center.y - [gesture locationInView:self.view].y);
      break;
      
    case UIGestureRecognizerStateChanged:
      view.center = CGPointMake([gesture locationInView:self.view].x + self.touchOffsetFromCenterOfPanningImageView.x,
                                [gesture locationInView:self.view].y + self.touchOffsetFromCenterOfPanningImageView.y);
      break;
      
    default:
      break;
  }
}

- (void)imagePinchedWithGesture:(UIPinchGestureRecognizer *)gesture {

  UIView *view = gesture.view;
  [view setTransform:CGAffineTransformScale(view.transform, [gesture scale], [gesture scale])];
  [gesture setScale:1.0];
}

- (void)imageRotatedWithGesture:(UIRotationGestureRecognizer *)gesture {
  
  UIView *view = gesture.view;
  [view setTransform:CGAffineTransformRotate(view.transform, [gesture rotation])];
  [gesture setRotation:0.0f];
}


#pragma mark - Show ImageView
- (void)showImageView:(UIView *)view {
  
  [self.view bringSubviewToFront:view];
  
  [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION
                   animations:^{
                     [view setAlpha:1.0];
                     [view setCenter:[self viewCenter]];
                   }];
}


#pragma mark - Reset ImageView
- (void)resetImageView:(UIView *)view {
  [self moveView:view offScreenWithCenter:[self offscreenPosition]];
}


- (void)moveView:(UIView *)view offScreenWithCenter:(CGPoint)center {
  [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION
                   animations:^{
                     [view setAlpha:0.0];
                     [view setCenter:center];
                   } completion:^(BOOL finished) {
                     [view setCenter:[self offscreenPosition]];
                   }];
}


#pragma mark - Position Helper Methods
- (CGPoint)offscreenPosition {
  return CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMinY(self.view.bounds) - CGRectGetHeight(self.view.bounds));
}

- (CGPoint)viewCenter {
  return CGPointMake(floorf(CGRectGetWidth(self.view.bounds)/2),
                     floorf(CGRectGetHeight(self.view.bounds))/2);
}


#pragma mark - AutoRotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
          toInterfaceOrientation == UIInterfaceOrientationLandscapeRight );
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskLandscape;
}


#pragma mark - Custom Recognizers

- (void)addCustomRecognizers
{
    //Hint: Draw a CT shape, as cursive
    CTGestureRecognizer *ctGesture = [[CTGestureRecognizer alloc] initWithTarget:self action:@selector(showCTView:)];
    [ctGesture setMinimumScoreThreshold:0.5];
    [self.view addGestureRecognizer:ctGesture];
    
    //Hint: Draw an S shape
    SPartyGestureRecognizer *sPartyGesture = [[SPartyGestureRecognizer alloc] initWithTarget:self action:@selector(showVideo:)];
    [sPartyGesture setMinimumScoreThreshold:0.5];
    [self.view addGestureRecognizer:sPartyGesture];
}

-(void)showVideo:(SPartyGestureRecognizer*)gesture
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vimeo.com/18874235"]];
}

-(void)showCTView:(CTGestureRecognizer*)gesture
{
    //We only want good CT's round these parts
    UIImageView *ctFace = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ctface.jpeg"]];
    [ctFace setCenter:[self viewCenter]];
    [self.view addSubview:ctFace];
    CABasicAnimation *scaleX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    //this is not used, as the group provides the duration
    scaleX.duration = 0;
    scaleX.autoreverses = NO;
    
    scaleX.toValue = [NSNumber numberWithFloat:5.0];
    scaleX.fromValue = [NSNumber numberWithFloat:0.25];
    scaleX.removedOnCompletion = YES;
    
    CABasicAnimation *scaleY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    //this is not used, as the group provides the duration
    scaleY.duration = 0;
    scaleY.autoreverses = NO;
    
    scaleY.toValue = [NSNumber numberWithFloat:5.0];
    scaleY.fromValue = [NSNumber numberWithFloat:0.25];
    scaleY.removedOnCompletion = YES;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue         = [NSNumber numberWithFloat:-3.0];
    rotate.toValue           = [NSNumber numberWithFloat:3.0];
    rotate.duration          = 0;
    rotate.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotate.removedOnCompletion = YES;
    rotate.autoreverses      = YES;
    
    //add in the translation animations
    
    NSArray* animationsArray = @[
                                 scaleX,
                                 scaleY,
                                 rotate
                                       ];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.5;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationGroup.animations = animationsArray;
    animationGroup.delegate = self;
    animationGroup.repeatCount = 5;
    animationGroup.autoreverses = YES;
    animationGroup.removedOnCompletion = YES;
    [animationGroup setValue:ctFace.layer forKey:@"animationLayer"];
    [ctFace.layer addAnimation:animationGroup forKey:@"CTAnimation"];
    [animationGroup setDelegate:self];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CALayer *layer = [anim valueForKey:@"animationLayer"];
    if (layer) {
        [layer removeFromSuperlayer];
    }
}

@end
