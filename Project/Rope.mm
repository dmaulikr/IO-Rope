//
//  Rope.m
//  WormRope
//
//  Created by Igor on 16.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Rope.h"


@interface Rope (PrivateMethods)
-(id) initRope:(b2World *)world startPoint:(b2Vec2)startPoint Hero:(b2Body*)bodyB;
-(void) CreateRope:(b2World *)world bodyA:(b2Body *)bodyA bodyB:(b2Body *)bodyB;
-(void) updateRopeState;
-(void) updateRopeSpriteState;
-(void) removeDeadRopes;
@end

@implementation Rope

@synthesize ropeLength = _ropeLenght;
@synthesize activeRopeLength = _activeRopeLength;

-(CGPoint) toPixels:(b2Vec2)point
{
	return CGPointMake(point.x*PTM_RATIO, point.y*PTM_RATIO);
}

-(b2Vec2) toMeters:(CGPoint)point
{
	return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
}


+(id) initRope:(b2World *)world startPoint:(b2Vec2)startPoint Hero:(b2Body *)bodyB
{
    return [[[self alloc] initRope:world startPoint:startPoint Hero:bodyB] autorelease];
}

-(id) initRope:(b2World *)world startPoint:(b2Vec2)startPoint Hero:(b2Body*)bodyB
{
    if (self = [super init]) {
        ropeSticks = [[NSMutableArray alloc] init];
        vRopes = [[NSMutableArray alloc] init];
        staticRopes = [[NSMutableArray alloc] init];
        
        sceneWorld = world;
        
        [self createCourner:startPoint];
        
        ropeSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rope1.png"];
        [self addChild:ropeSpriteSheet];
        
        [self CreateRope:world bodyA:currentCorner bodyB:bodyB];
        
        CGPoint startStickPos = [self toPixels:currentCorner->GetPosition()];
        
        NSValue* sticksCoordinate = [NSValue valueWithCGPoint:startStickPos];
        
        [ropeSticks addObject:sticksCoordinate];
        
        

        ropeJointBody = currentCorner;
        heroBody = bodyB;
        
      //  [self schedule:@selector(update:) interval:0.01f];
        
        [self scheduleUpdate];
    }
    return self;
    
}


-(void) createCourner:(b2Vec2) position
{

    b2BodyDef cornerBodyDef;
    cornerBodyDef.type = b2_staticBody;
    
    
    b2FixtureDef cornerFixtureDef;
    cornerFixtureDef.filter.maskBits = 0x0000;
    
    b2CircleShape cshape;
    cshape.m_radius = 0.05f;
    
    cornerFixtureDef.shape = &cshape;
    
    cornerBodyDef.position = position;
    
    b2Body* cornerBody = sceneWorld->CreateBody(&cornerBodyDef);
    
    cornerBody->CreateFixture(&cornerFixtureDef);
    
    currentCorner = cornerBody;
}


-(void) update: (ccTime) dt
{
    [self updateRopeState];
    for (VRope *rope in vRopes)
    {
        [rope update:dt];
        [rope updateSprites];
    }
}

-(void) updateRopeState {
    
    RaysCastCallback callback;
    
    sceneWorld->RayCast(&callback, heroBody->GetPosition() ,ropeJointBody->GetPosition());
    
    
    if (callback.m_fixture)
    {
    if (callback.m_fixture->GetBody() != ropeJointBody)
    {
        
        b2PolygonShape* shape = (b2PolygonShape*)callback.m_fixture->GetShape();
        b2Vec2 centerOfShape = callback.m_fixture->GetBody()->GetPosition() + shape->m_centroid;
        
        int count = shape->GetVertexCount();
        
        b2Vec2 succesPoint;
        float32 succesLenght=10000;
        
        for (int i=0;i<count;i++)
        {
            b2Vec2 vertex = shape->GetVertex(i);
            b2Vec2 cast = vertex+callback.m_fixture->GetBody()->GetPosition();
           // callback.m_fixture->GetBody()->
            float32 lenght = (cast-callback.m_point).Length();
            if (lenght<succesLenght)
            {
                succesLenght=lenght;
                succesPoint = cast;
            }
            
        }
        
        b2Vec2 broadcast = succesPoint - centerOfShape;
        
        b2Body* lastUsedCourner = currentCorner;
        
        [self createCourner:succesPoint+0.07/broadcast.Length()*broadcast];
        
        VRope* staticRope = [[VRope alloc] initWithPoints:[self toPixels:ropeJointBody->GetPosition()] pointB:[self toPixels:currentCorner->GetPosition()]spriteSheet:ropeSpriteSheet];
        [staticRopes addObject:staticRope];
        [staticRope release];
        
        b2RopeJoint* joint = currentRopeJoint;
        currentRopeJoint = nil;
        sceneWorld->ClearForces();
        sceneWorld->DestroyJoint(joint);
        
        [self CreateRope:sceneWorld bodyA:currentCorner bodyB:heroBody];
        ropeJointBody = currentCorner;
        
        CGPoint startStickPos = [self toPixels:currentCorner->GetPosition()];
        
        NSValue* sticksCoordinate = [NSValue valueWithCGPoint:startStickPos];
        
        [ropeSticks addObject:sticksCoordinate];
        
        
        
        if (lastUsedCourner != nil)
        {
            sceneWorld->DestroyBody(lastUsedCourner);
        }
        

    }
    }
    if (ropeSticks.count>1)
    {
        
        NSValue* val = [ropeSticks objectAtIndex:ropeSticks.count-2];
        CGPoint pos;
        [val getValue:&pos];
        RaysCastCallback callback;
        sceneWorld->RayCast(&callback, [self toMeters:pos], heroBody->GetPosition());
        if (callback.m_fixture)
        {
        if (callback.m_fixture->GetBody() == heroBody)
        {
            
            
            
            float32 length1 = ([self toMeters:pos] - heroBody->GetPosition()).Length();
            float32 length2 = ([self toMeters:pos] - currentCorner->GetPosition()).Length()+(currentCorner->GetPosition()-heroBody->GetPosition()).Length();
            float32 lenghtResult = length1 - length2;
            
            if (lenghtResult<0.15f && lenghtResult>-0.15f)
            {
                b2Body* lastUsedCourner = currentCorner;
                
                [self createCourner:[self toMeters:pos]];
                
                b2RopeJoint* joint = currentRopeJoint;
                currentRopeJoint = nil;
                sceneWorld->ClearForces();
                sceneWorld->DestroyJoint(joint);
                [self CreateRope:sceneWorld bodyA:currentCorner bodyB:heroBody];
                ropeJointBody = currentCorner;
                
                [ropeSticks removeObjectAtIndex:ropeSticks.count-1];
                
                if (lastUsedCourner != nil)
                {
                    sceneWorld->DestroyBody(lastUsedCourner);
                }
                
                VRope *deadStatic = [staticRopes objectAtIndex:staticRopes.count-1];
                [deadStatic removeSprites];
                [staticRopes removeObject:deadStatic];

                //[deadStatic release];
            }
        }
        
    }
    }
}

-(void) updateRopeSpriteState
{
}

/*
-(void) removeDeadRopes
{
	// Sort the nuke array to group duplicates.
	std::sort(ropeToRelease, ropeToRelease + ropeToreleaseCount);
	
	// Destroy the bodies, skipping duplicates.
	unsigned int i = 0;
	while (i < ropeToreleaseCount)
	{
        VRope* rope = ropeToRelease[i++];
        [rope release];
		
	}
	
	ropeToreleaseCount = 0;
}
*/

-(void) CreateRope:(b2World *)world bodyA:(b2Body *)bodyA bodyB:(b2Body *)bodyB
{
        b2RopeJointDef stickJoint;
        stickJoint.localAnchorA = bodyA->GetLocalCenter();
        stickJoint.localAnchorB = bodyB->GetLocalCenter();
        stickJoint.collideConnected = NO;
        stickJoint.maxLength = (bodyA->GetPosition()-bodyB->GetPosition()).Length();
        stickJoint.bodyA = bodyA;
        stickJoint.bodyB = bodyB;
        currentRopeJoint = (b2RopeJoint *)world->CreateJoint(&stickJoint);
        
        if (vRopes.count>0)
        {
        VRope* rope = [vRopes objectAtIndex:vRopes.count-1];
        [rope removeSprites];
        [vRopes removeObject:rope];
        //[rope release];
        }
    
    VRope *newRope = [[VRope alloc] initWithRopeJoint:currentRopeJoint spriteSheet:ropeSpriteSheet];
    [vRopes addObject:newRope];
    [newRope release];

}

-(void) changeMaxLenghtHight:(float) speed
{
    
    float speedRatio = speed / 10;
    
    b2RopeJoint* joint = currentRopeJoint;
    currentRopeJoint = nil;
    sceneWorld->ClearForces();
    sceneWorld->DestroyJoint(joint);
    
    b2Vec2 posVec = currentCorner->GetPosition() - heroBody->GetPosition();
    
    b2Vec2 newPos = (heroBody->GetPosition() + (speedRatio/posVec.Length())*(posVec));
    
    heroBody->SetTransform( newPos, heroBody->GetAngle());
    
    [self CreateRope:sceneWorld bodyA:currentCorner bodyB:heroBody];
    ropeJointBody = currentCorner;
     
    
    /*
    currentRopeJoint->SetMaxLength(currentRopeJoint->GetMaxLength()+1.05f);
    
    VRope* rope = [vRopes objectAtIndex:vRopes.count-1];
    [rope removeSprites];
    [vRopes removeObject:rope];
    
    VRope *newRope = [[VRope alloc] initWithRopeJoint:currentRopeJoint spriteSheet:ropeSpriteSheet];
    
    [vRopes addObject:newRope];
    [newRope release];
     */
}

-(void) changeMaxLenghtLow:(float) speed
{
    
    float speedRatio = speed / 10;
    
    b2Vec2 posVec = currentCorner->GetPosition() - heroBody->GetPosition();
    
    if (posVec.Length()>1.0f)
    {
    
    b2RopeJoint* joint = currentRopeJoint;
    currentRopeJoint = nil;
    sceneWorld->ClearForces();
    sceneWorld->DestroyJoint(joint);
    
    b2Vec2 newPos = (heroBody->GetPosition() + (speedRatio/posVec.Length())*(posVec));
    
    heroBody->SetTransform(newPos, heroBody->GetAngle());
    
    [self CreateRope:sceneWorld bodyA:currentCorner bodyB:heroBody];
    ropeJointBody = currentCorner;
        
    }
    
    /*
    currentRopeJoint->SetMaxLength(currentRopeJoint->GetMaxLength()-0.05f);
    
    VRope* rope = [vRopes objectAtIndex:vRopes.count-1];
    [vRopes removeObject:rope];
    [rope removeSprites];
    VRope *newRope = [[VRope alloc] initWithRopeJoint:currentRopeJoint spriteSheet:ropeSpriteSheet];
    
    [vRopes addObject:newRope];
    [newRope release];
     */
    
}

-(b2Vec2) returnCurrentCornerPosition
{
    return currentCorner->GetPosition();
}

-(void) dealloc
{
    [staticRopes release];
    [vRopes release];
    [ropeSticks release];
    [super dealloc];
}

@end
