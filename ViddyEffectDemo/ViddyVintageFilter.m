//
//  ViddyVintageFilter.m
//  ViddyEffectDemo
//
//  Created by Rex Sheng on 10/30/12.
//  Copyright (c) 2012 Rex.S Lab. All rights reserved.
//

#import "ViddyVintageFilter.h"

@implementation ViddyVintageFilter

- (id)init
{
	if (self = [super init]) {
		
		UIImage *image = [UIImage imageNamed:@"bw_overlay.png"];
		
		NSURL *movieURL = [[NSBundle mainBundle] URLForResource:@"vintage_overlay" withExtension:@"m4v"];
		GPUImageMovie *movieFile = [[GPUImageMovie alloc] initWithAsset:[AVAsset assetWithURL:movieURL]];
//		movieFile.runBenchmark = YES;
		movieFile.playAtActualSpeed = YES;
		
		GPUImagePicture *imageFile = [[GPUImagePicture alloc] initWithImage:image];
		GPUImageUnsharpMaskFilter *filter = [[GPUImageUnsharpMaskFilter alloc] init];
		
		[movieFile addTarget:filter];
		[imageFile addTarget:filter];
		[imageFile processImage];
//		[movieFile startProcessing];
		
		self.initialFilters = @[filter];
		self.terminalFilter = filter;
	}
	return self;
}
@end
