//
//  Star.m
//  Project
//
//  Created by Igor on 27.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Star.h"


@implementation Star


-(id) initStar:(CGPoint)position world:(b2World *)world layer:(GamePlayLayer *)layer
{
    if(self = [super initBonus:@"Icon-72.png" position:position world:world layer:layer]) {
        self.body->SetUserData(self);
    }
	return self;
}

+(id) initStar:(CGPoint)position world:(b2World *)world layer:(GamePlayLayer *)layer
{
    return [[[self alloc] initStar:position world:world layer:layer] autorelease];

}

@end
