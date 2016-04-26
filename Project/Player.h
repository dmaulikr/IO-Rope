//
//  Player.h
//  Project
//
//  Created by Igor on 18.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Rope.h"

@class GamePlayLayer;

@interface Player : CCNode {
    CCSprite            *_sprite;
    Rope                *playerRope;
    b2Body              *_body;
}

@property(nonatomic,assign)b2Body *body;
@property(nonatomic,assign)CCSprite *sprite;

+(id) initPlayer:(CGPoint)position world:(b2World *)world layer:(GamePlayLayer *)layer;
-(void) setInstantRopeForPlayer:(Rope *)rope;
-(void) playerDie;

@end
