//
//  GameInterfaceLayer.m
//  Project
//
//  Created by Igor on 18.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameInterfaceLayer.h"
#import "GamePlayLayer.h"

#define PTM_RATIO 32

@interface GameInterfaceLayer(PrivateMethods)
-(void) addLeftJoystick;
-(void) addRightJoystick;
@end


@implementation GameInterfaceLayer

-(b2Vec2) toMeters:(CGPoint)point
{
	return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
}



-(id) init
{
	if ((self = [super init]))
	{
        [self addLeftJoystick];
        [self addRightJoystick];
	}
	
	return self;
}

-(void) addRightJoystick
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    rightJoystick	 = [ZJoystick joystickNormalSpriteFile:@"palka2.png"
                                      selectedSpriteFile:@"palka2.png"
                                    controllerSpriteFile:@"knopka2.png" joystickType:kJoystickUDAxes];
    rightJoystick.position          = ccp(s.width-120 , 130);
    
    rightJoystick.delegate          = self;    //Joystick Delegate
    //_joystick2.controlledObject  = globalSprite;
    rightJoystick.speedRatio        = 1.0f;
    rightJoystick.joystickRadius    = 70.0f;   //added in v1.2
    
    [self addChild:rightJoystick];
}

-(void) addLeftJoystick
{
    leftJoystick		 = [ZJoystick joystickNormalSpriteFile:@"palka2.png"
                                      selectedSpriteFile:@"palka2.png"
                                    controllerSpriteFile:@"knopka2.png" joystickType:kJoystickUDAxes];
    leftJoystick.position          = ccp(120 , 130);
    
    leftJoystick.delegate          = self;    //Joystick Delegate
    //_joystick2.controlledObject  = globalSprite;
    leftJoystick.speedRatio        = 1.0f;
    leftJoystick.joystickRadius    = 70.0f;   //added in v1.2
    
    [self addChild:leftJoystick];
}

-(void)joystickControlDidUpdate:(id)joystick toXSpeedRatio:(CGFloat)xSpeedRatio toYSpeedRatio:(CGFloat)ySpeedRatio{
    if (joystick == rightJoystick)
    {
        GamePlayLayer* game = [GamePlayLayer sharedGamePlayLayer];
        game.rotation = game.rotation-ySpeedRatio*1;

        b2World* world = [GamePlayLayer sharedWorld];
        
        b2Vec2 currentGravity = world->GetGravity();
        
        
        float angle = -1*CC_DEGREES_TO_RADIANS(ySpeedRatio);///-57.29599*1;
        
        float x = currentGravity.x * cosf(angle) - currentGravity.y * sinf(angle);
        float y = currentGravity.y * cosf(angle) + currentGravity.x * sinf(angle);
        
        
        b2Vec2 gravity = b2Vec2(x, y);
        
       // CCLOG(@"gravity x:%f", gravity.x/game.rotation);
       // CCLOG(@"gravity y:%f", gravity.y/game.rotation);
        
        world->SetGravity(gravity);
    }
    
    if (joystick == leftJoystick)
    {
        Rope* rope = [GamePlayLayer sharedRope];
        if (ySpeedRatio>0)
        {
            [rope changeMaxLenghtLow:ySpeedRatio];
        }
        if (ySpeedRatio<0)
        {
            [rope changeMaxLenghtHight:ySpeedRatio];
        }
         
    }
    
}


-(void) dealloc
{
	[super dealloc];
}

@end
