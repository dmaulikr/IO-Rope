//
//  Thorns.m
//  Project
//
//  Created by Igor on 01.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Thorns.h"
#import "Player.h"

#define PTM_RATIO 32

@interface Thorns (PrivateMethods)
-(id) initThorns:(b2Body *)body layer:(GamePlayLayer *)layer;
@end


@implementation Thorns


+(id) initThorns:(b2Body *)body layer:(GamePlayLayer *)layer
{
    return [[[self alloc] initThorns:body layer:layer] autorelease];
}

-(id) initThorns:(b2Body *)body layer:(GamePlayLayer *)layer
{
    if(self = [super initStaticEnemiesWithBody:body layer:layer]) {
        _body->SetUserData(self);
        _sprite = nil;
    }
	return self;
}

-(void) contactedByPlayer:(Player *)player
{
    [player playerDie];
}


@end
