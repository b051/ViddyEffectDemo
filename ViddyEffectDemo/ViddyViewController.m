//
//  ViddyViewController.m
//  FilterShowcase
//
//  Created by Rex Sheng on 10/30/12.
//  Copyright (c) 2012 Cell Phone. All rights reserved.
//

#import "ViddyViewController.h"
#import "iCarousel.h"
#import <GPUImage/GPUImage.h>
#import "ViddyVintageFilter.h"

@interface ViddyViewController () <iCarouselDataSource, iCarouselDelegate>

@end

@implementation ViddyViewController
{
	GPUImageVideoCamera *videoCamera;
	GPUImageFilterPipeline *pipeline;
	GPUImageView *filterView;
	NSArray *effects;
	NSArray *effectsConfiguration;
}

- (void)sliderValueChanged:(UISlider *)slider
{
	
}

- (void)selectVintage:(id)sender
{
	
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	filterView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[self.view addSubview:filterView];
	
	CGSize size = self.view.bounds.size;
	effects = @[@"vintage", @"soho", @"bw"];
	NSDictionary *conf = @{@"Filters" : @[
	@{@"FilterName" : @"GPUImageSepiaFilter"},
	@{@"FilterName" : @"GPUImagePixellateFilter", @"Attributes" : @{@"setFractionalWidthOfAPixel:" : @"float(0.05)"}}
	]};

	NSDictionary *vintage = @{@"Filters" : @[
	@{@"FilterName" : @"ViddyVintageFilter"}
	]};
	NSDictionary *soho = @{@"Filters" : @[
	@{@"FilterName" : @"GPUImageVignetteFilter"}
	]};
	NSDictionary *bw = @{@"Filters" : @[
	@{@"FilterName" : @"GPUImageGrayscaleFilter"}
	]};
	effectsConfiguration = @[vintage, soho, bw];
	
	UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(15, size.height - 100, size.width - 30, 20)];
	slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	[slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:slider];
	
	iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, size.height - 80, size.width, 80)];
	carousel.dataSource = self;
	carousel.delegate = self;
	carousel.centerItemWhenSelected = NO;
	carousel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:carousel];
	
	videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
	videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
	
	GPUImageGrayscaleFilter *filter = [[GPUImageGrayscaleFilter alloc] init];
	[videoCamera addTarget:filter];
	[filter addTarget:filterView];
	
	pipeline = [[GPUImageFilterPipeline alloc] initWithConfiguration:effectsConfiguration[0]
															   input:videoCamera
															  output:filterView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[videoCamera startCameraCapture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [videoCamera stopCameraCapture];
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - iCarousel Delegate & DataSource
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
	[videoCamera pauseCameraCapture];
	pipeline = [[GPUImageFilterPipeline alloc] initWithConfiguration:effectsConfiguration[index]
															   input:videoCamera
															  output:filterView];
	[videoCamera resumeCameraCapture];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
	return effects.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
	return 90;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	if (!view) {
		view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
	}
	[(UIImageView *)view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", effects[index]]]];
	return view;
}

@end
