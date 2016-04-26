//
//  Player.m
//  Project
//
//  Created by Igor on 18.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "GamePlayLayer.h"
#import "Rope.h"

#define PTM_RATIO 32

@interface Player (PrivateMethods)
-(id) initPlayer:(CGPoint)position world:(b2World *)world layer:(CCLayer *)layer;
-(void) initPhysicalBody:(CGPoint)position world:(b2World *)world;
-(void) initSprite:(NSString *)fileName  layer:(CCLayer*) layer;
-(void) updatePlayerRotation;
-(void) velocityStable;
@end

NSString* spriteFileName = @"hero.png";


@implementation Player

@synthesize body = _body;
@synthesize sprite = _sprite;

+(id) initPlayer:(CGPoint)position world:(b2World *)world layer:(GamePlayLayer *)layer
{
    return [[[self alloc] initPlayer:position world:world layer:layer] autorelease];
    
}

-(id) initPlayer:(CGPoint)position world:(b2World *)world layer:(GamePlayLayer *)layer
{
    if (self = [super init]) {
        [self initSprite:spriteFileName layer:layer];
        [self initPhysicalBody:position world:world];
        playerRope = nil;
        [self scheduleUpdate];
        
    }
    return self;
}

-(void) initSprite:(NSString *)fileName  layer:(GamePlayLayer*) layer;
{
    _sprite = [CCSprite spriteWithFile:fileName];
    [layer addChild:_sprite z:1];
    
}

-(void) initPhysicalBody:(CGPoint)position world:(b2World *)world
{
    
     b2BodyDef bodyDef;
     bodyDef.type = b2_dynamicBody;
     bodyDef.position.Set((position.x)/PTM_RATIO,(position.y)/PTM_RATIO);
    
     _body = world->CreateBody(&bodyDef);
    
     b2FixtureDef boxDef;
    
     b2PolygonShape box;
     box.SetAsBox(self.sprite.contentSize.width/2.0f/PTM_RATIO, self.sprite.contentSize.height/2.0f/PTM_RATIO);
    
     b2CircleShape cshape;
     cshape.m_radius = self.sprite.contentSize.width/2.0f/PTM_RATIO;
    
     boxDef.friction =0.5;
     boxDef.restitution = 0.2;
     boxDef.density = 1.0f;
     // boxDef.filter.maskBits = b2MaskForNonCollisionBodies;
     boxDef.shape = &cshape;
     _body->SetUserData(self);
     _body->CreateFixture(&boxDef);
     _body->SetSleepingAllowed(NO);
    
    b2FixtureDef collisionFixture;
    collisionFixture.density = 0.0f;
    b2CircleShape collisionFixtureCShape;
    collisionFixtureCShape.m_radius = self.sprite.contentSize.width/2.0f/PTM_RATIO + 0.1f;
    collisionFixture.shape = &collisionFixtureCShape;
    
    _body->CreateFixture(&collisionFixture);

    
}

-(void) update: (ccTime) dt
{
    self.sprite.position = CGPointMake(self.body->GetPosition().x * PTM_RATIO, self.body -> GetPosition().y * PTM_RATIO);
    
    //self.sprite.rotation = -1.0 * CC_RADIANS_TO_DEGREES(body->GetAngle());
    
    [self velocityStable];
    if (playerRope != nil)
    {
        [self updatePlayerRotation];
    }
}

-(void) updatePlayerRotation {
    
    b2Vec2 kAngle = [playerRope returnCurrentCornerPosition];
    kAngle = kAngle - _body->GetPosition();
    float angle = -1*atan2f(kAngle.x, kAngle.y);
    //body->SetTransform(body->GetPosition(), angle); // Update only Sprite rotation ?
    self.sprite.rotation = -1.0 * CC_RADIANS_TO_DEGREES(angle);
    
}


-(void) setInstantRopeForPlayer:(Rope *)rope
{
    playerRope = rope;
}

-(void) velocityStable
{
        b2Vec2 currentVelocity = self.body->GetLinearVelocity();
        b2Vec2 velocityStabile = -1.0f * currentVelocity;
        self.body->ApplyForceToCenter(velocityStabile);
}


-(void) playerDie
{
    CCLOG(@"omfg!!! i'm die =(");
}
@end
