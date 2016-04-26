//
//  StaticEnemies.m
//  Project
//
//  Created by Igor on 01.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "StaticEnemies.h"
#import "GamePlayLayer.h"
#import "Player.h"

@implementation StaticEnemies

@synthesize body = _body;
@synthesize sprite = _sprite;

-(id) initStaticEnemiesWithBody:(b2Body*)body layer:(GamePlayLayer *)layer;
{
    if (self = [super init]) {
        _body = body;
        //[self scheduleUpdate];
        
    }
    return self;
}

-(void) contactedByPlayer:(Player *)player
{
    // contact;
}

@end
