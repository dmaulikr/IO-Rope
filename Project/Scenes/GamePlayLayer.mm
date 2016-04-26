//
//  GamePlayLayer.m
//  Testing
//
//  Created by Tim Roadley on 10/08/11.
//  Copyright 2011 Tim Roadley. All rights reserved.
//

#import "GamePlayLayer.h"
#import "Player.h"
#import "Star.h"
#import "Thorns.h"

@implementation GamePlayLayer

@synthesize iPad, device;


GamePlayLayer *instanceOfGamePlayLayer;
b2World *instanceOfWorld;
Rope *instanceOfRope;
Player *instanceOfPlayer;

//Cat* instanceOfSceneHero;

+(GamePlayLayer*) sharedGamePlayLayer
{
	//NSAssert(instanceOfGameScene != nil, @"GameScene instance not yet initialized!");
	return instanceOfGamePlayLayer;
}

+(b2World*) sharedWorld
{
    return instanceOfWorld;
}

+(Rope*) sharedRope
{
    return instanceOfRope;
}

-(void) initMapTexture
{
    //
    // Init Map Sprite
    //
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCSprite* map = [CCSprite spriteWithFile:@"all.png"];
    map.position = ccp(s.width/2, s.height/2);
    [self addChild:map];
    
    //
    //
    //
    
    //
    // Init Phycics Shape
    //
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"cflevel1.plist"];
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    
    bodyDef.position.Set(s.width/2/PTM_RATIO, s.height/2/PTM_RATIO);
    b2Body *body = world->CreateBody(&bodyDef);
    
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:@"all"];
    
    //
    //
    //

}

-(void) WorldScroll
{

    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    
    //CGPoint centreOfCurrentView = ccp(self.position.x + centerOfView.x, self.position.y + centerOfView.y);
    
    CGPoint playerLocalPosition = ccp(instanceOfPlayer.sprite.position.x, instanceOfPlayer.sprite.position.y);
    
    CGPoint scrollPointer = ccp(centerOfView.x-playerLocalPosition.x, centerOfView.y-playerLocalPosition.y);
    
    //float angle = -1*CC_DEGREES_TO_RADIANS(ySpeedRatio);///-57.29599*1;
    
    //float x = currentGravity.x * cosf(angle) - currentGravity.y * sinf(angle);
    
    float angle = -1*CC_DEGREES_TO_RADIANS(self.rotation);
    
    float x = scrollPointer.x * cosf(angle) - scrollPointer.y * sinf(angle);
    float y = scrollPointer.y * cosf(angle) + scrollPointer.x * sinf(angle);
    
    CGPoint resultLocation = ccp(x, y);

    
    //self.position = resultLocation;
    
    [self setPosition:resultLocation];

     
  //  [self.camera setCenterX:instanceOfPlayer.sprite.position.x centerY:instanceOfPlayer.sprite.position.y centerZ:0];
  //  [self.camera setEyeX:instanceOfPlayer.sprite.position.x eyeY:instanceOfPlayer.sprite.position.y eyeZ:10];
    //[self runAction:[CCFollow actionWithTarget:instanceOfPlayer.sprite]];

}


-(id) init
{
	if( (self=[super init])) {
        
        instanceOfGamePlayLayer = self;
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        
		// enable events
		self.isTouchEnabled = YES;
		//self.isAccelerometerEnabled = YES;
        
        [self initPhysics];
        
        [self initMapTexture];
        
        Player* player = [Player initPlayer:CGPointMake(s.width*0.5, s.height*0.4) world:world layer:self];
        [self addChild:player];
        
        instanceOfPlayer = player;
        
        b2Vec2 startPoint = b2Vec2((s.width*0.5)/PTM_RATIO,(s.height*0.5)/PTM_RATIO);
        
        Rope* rope = [Rope initRope:world startPoint:startPoint Hero:player.body];
        [self addChild:rope];
        
        [player setInstantRopeForPlayer:rope];
        
        
        /*
        Star* star = [Star initStar:ccp((s.width*0.5),s.height*0.5) world:world layer:self];
        [self addChild:star];
         */
        
        instanceOfRope = rope;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position.Set((s.width*0.5)/PTM_RATIO,(s.height*0.5)/PTM_RATIO);
        bodyDef.fixedRotation = YES;
        body2 = world->CreateBody(&bodyDef);
        
        [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body2 forShapeName:@"all2"];
        

        /*
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
        bodyDef.position.Set((s.width*0.5)/PTM_RATIO,(s.height*0.2)/PTM_RATIO);
        bodyDef.fixedRotation = YES;
        body2 = world->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(140.0/PTM_RATIO/2, 40.0/PTM_RATIO/2);//These are mid points for our 1m box
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;
        fixtureDef.density = 0.5f;
        fixtureDef.friction = 0.2f;
        fixtureDef.restitution = 0.2f;
        body2->CreateFixture(&fixtureDef);
        */ 
        
        nukeCount = 0;
        
        
        
        Thorns *thorn = [Thorns initThorns:body2 layer:self];
        [self addChild:thorn];
         
         
        
		[self scheduleUpdate];

        
	}
	return self;
}



-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
    
    instanceOfWorld = world;
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
    
    ContactListener* contactListener = new ContactListener();
    world->SetContactListener(contactListener);
	
	/*
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
    */
    
    
    /*
    
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"level1.plist"];
    
     b2BodyDef bodyDef;
     bodyDef.type = b2_staticBody;
    
     bodyDef.position.Set(s.width/2/PTM_RATIO, s.height/2/PTM_RATIO);
     b2Body *body = world->CreateBody(&bodyDef);
    
     [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:@"all1"];
     */
    
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
     ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
     
     kmGLPushMatrix();
     
     world->DrawDebugData();
     
     kmGLPopMatrix();
     
     
}

-(void) removeB2bodyFromLayer:(b2Body *)body
{
	nuke[nukeCount++] = body;
}

-(void) removeB2Bodies
{
	// Sort the nuke array to group duplicates.
	std::sort(nuke, nuke + nukeCount);
	
	// Destroy the bodies, skipping duplicates.
	unsigned int i = 0;
	while (i < nukeCount)
	{
		b2Body* b = nuke[i++];
		while (i < nukeCount && nuke[i] == b)
		{
			++i;
		}
        
		// IMPORTANT: don't alter the order of the following commands, or it might crash.
		
		// 1. obtain a weak ref to the BodyNode
		Bonus *node = (Bonus*) b->GetUserData();
		
		// 2. destroy the b2body
		world->DestroyBody(b);
        
		// 3. set the the body to NULL
		[node setBody:NULL];
		
		// 4. remove BodyNode
		[node removeFromParentAndCleanup:YES];
        
		
	}
	
	nukeCount = 0;
}


-(void) update: (ccTime) dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
    uint substeps = 5;
    float32 subdt = dt / substeps;
    
    for (uint i = 0; i < substeps; i++) {
        world->Step(subdt, velocityIterations, positionIterations);
        
        // do your physics-related stuff inside here but leave any sprites manipulation outside this loop
    }
    
    [self removeB2Bodies];
    [self WorldScroll];
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
          }
}



-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	[super dealloc];
}


@end
