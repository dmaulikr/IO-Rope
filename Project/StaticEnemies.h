//
//  StaticEnemies.h
//  Project
//
//  Created by Igor on 01.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@class GamePlayLayer;
@class Player;


@interface StaticEnemies : CCNode {
    b2Body              *_body;
    CCSprite            *_sprite;
}

@property(nonatomic,assign)b2Body *body;
@property(nonatomic,assign)CCSprite *sprite;

-(id) initStaticEnemiesWithBody:(b2Body*)body layer:(GamePlayLayer *)layer;
-(void) contactedByPlayer:(Player*) player;

@end
