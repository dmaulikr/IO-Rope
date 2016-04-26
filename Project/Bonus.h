//
//  Bonus.h
//  Project
//
//  Created by Igor on 27.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"
#import "GameConfig.h"

@class GamePlayLayer;

@interface Bonus : CCNode {
    CCSprite            *_sprite;
    b2Body              *_body;
    GamePlayLayer       *level;
}

@property (nonatomic,assign) CCSprite *sprite;
@property (nonatomic,assign) b2Body *body;

-(id) initBonus:(NSString *)fileName position:(CGPoint)position world:(b2World *)world layer:(GamePlayLayer *)layer;
-(void) initSquaredPhysicalBody:(CGPoint)position world:(b2World *)world;
-(void) initSprite:(NSString *)fileName layer:(GamePlayLayer*)layer;
-(void) contactedByPlayer;


@end
