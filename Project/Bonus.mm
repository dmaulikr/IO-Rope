//
//  Bonus.m
//  Project
//
//  Created by Igor on 27.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Bonus.h"
#import "GamePlayLayer.h"

#define PTM_RATIO 32


@interface Bonus (PrivateMethods)
@end

@implementation Bonus

@synthesize body = _body;
@synthesize sprite = _sprite;

-(id) initBonus:(NSString *)fileName position:(CGPoint)position world:(b2World *)world layer:(GamePlayLayer*)layer
{
    if((self = [super init])) {
    level = layer;
    [self initSprite:fileName layer:layer];
    _sprite.position = position;
    [self initSquaredPhysicalBody:position world:world];
    }
    return self;
}

-(void) initSquaredPhysicalBody:(CGPoint)position world:(b2World *)world;
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set((position.x)/PTM_RATIO,(position.y)/PTM_RATIO);;
    _body = world->CreateBody(&bodyDef);
    b2FixtureDef boxDef;
    b2PolygonShape box;
    boxDef.friction =0.2;
    boxDef.restitution = 0.2;
    boxDef.density = 1.0f;
    box.SetAsBox(self.sprite.contentSize.width/2.0f/PTM_RATIO, self.sprite.contentSize.height/2.0f/PTM_RATIO);
    boxDef.shape = &box;
   // boxDef.filter.maskBits = b2MaskForNonCollisionBodies;
    boxDef.isSensor = YES;
    _body->CreateFixture(&boxDef);
    _body->SetUserData(self);
}

-(void) initSprite:(NSString *)fileName layer:(GamePlayLayer*)layer
{
    _sprite = [CCSprite spriteWithFile:fileName];
    [layer addChild:_sprite];
}

-(void) contactedByPlayer
{
    
    self.visible = NO;
    _sprite.visible = NO;
    _body->SetUserData(NULL);
    [level removeB2bodyFromLayer:_body];
    /*
    self.visible = false;
    self.sprite.visible = false;
   // _body->SetUserData(NULL);
   b2World* world = _body->GetWorld();
    
    self.body = NULL;
    //_body->SetUserData(NULL);
    world->ClearForces();
    world->DestroyBody(_body);
     */
}


@end
