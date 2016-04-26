//
//  DeviceManager.m
//  Cat
//
//  Created by Macbook on 19.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DeviceManager.h"


@implementation DeviceManager

@synthesize device;

- (id)init
{
    if (self = [super init]) {
    [self returnCurrentDeviceToDeviceManager];
    }
    return self;
}


-(void) returnCurrentDeviceToDeviceManager
{
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		if( CC_CONTENT_SCALE_FACTOR() == 2 )
        {
			self.device = IpadRetina;
            CCLOG(@"Ipad Retina");
        }
		else
        {
			self.device = Ipad;
            CCLOG(@"Ipad");
        }
	}
	else
	{
		if( CC_CONTENT_SCALE_FACTOR() == 2 )
        {
			self.device = IphoneRetina;
            CCLOG(@"Iphone Retina");
        }
		else
        {
			self.device = Iphone;
            CCLOG(@"Iphone");
        }
	}
}


@end
