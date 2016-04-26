//
//  GamePlayLayer.h
//  Testing
//
//  Created by Tim Roadley on 10/08/11.
//  Copyright 2011 Tim Roadley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "GameConfig.h"
#import "ContactListener.h"
#import "GB2ShapeCache.h"
#import "Rope.h"

@interface GamePlayLayer : CCLayer
 {
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    b2Body* body2;
    unsigned int nukeCount;
    b2Body* nuke[10];
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;

+(GamePlayLayer*) sharedGamePlayLayer;
+(b2World*) sharedWorld;
+(Rope*) sharedRope;
-(void) removeB2bodyFromLayer:(b2Body*)body;

@end