//
//  Rope.h
//  WormRope
//
//  Created by Igor on 16.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RaysCastCallback.h"
#import "VRope.h"

#define PTM_RATIO 32

@interface Rope : CCNode {
    NSMutableArray              *ropeSticks;
    NSMutableArray              *vRopes;
    NSMutableArray              *staticRopes;
   // NSMutableArray              *ropesToRelease;
   // VRope                        *ropeToRelease[100];
   // unsigned int                ropeToreleaseCount;
    CCSpriteBatchNode           *ropeSpriteSheet;
    b2Body                      *ropeJointBody;
    b2Body                      *heroBody;
    b2World                     *sceneWorld;
    b2RopeJoint                 *currentRopeJoint;
    b2Body                      *currentCorner;
    
    float                       _ropeLenght; // length of all rope
    
    float                       _activeRopeLength; // length of active rope (lst stick)
}

@property (nonatomic,assign) float ropeLength;
@property (nonatomic,assign) float activeRopeLength;


+(id) initRope:(b2World *)world startPoint:(b2Vec2)startPoint Hero:(b2Body*)bodyB;
-(void) changeMaxLenghtHight:(float) speed;
-(void) changeMaxLenghtLow:(float) speed;
-(b2Vec2) returnCurrentCornerPosition;

@end
