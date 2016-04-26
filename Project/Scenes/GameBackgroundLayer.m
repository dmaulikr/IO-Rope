//
//  GameBackgroundLayer.m
//  Testing
//
//  Created by Tim Roadley on 10/08/11.
//  Copyright 2011 Tim Roadley. All rights reserved.
//

#import "GameBackgroundLayer.h"

@implementation GameBackgroundLayer

- (id)init
{
    self = [super init];
    if (self != nil) {
        
        /*
        
        CCLayerGradient *gradientBackground = [CCLayerGradient layerWithColor:ccc4(255,255,255,255)
                                                                     fadingTo:ccc4(0,0,0,0)
                                                                  alongVector:ccp(0,1)]; 
        
        [self addChild:gradientBackground];
         
        */
        
        /*
        CCSprite* background = [CCSprite spriteWithFile:@"sky.png"];
        CGSize s = [CCDirector sharedDirector].winSize;
        background.position = ccp(s.width/2, s.height/2);
        [self addChild:background];
         */
        
    }
    return self;
}

@end


