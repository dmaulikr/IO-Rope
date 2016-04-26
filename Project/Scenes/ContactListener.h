/*
 *  ContactListener.h
 *  PhysicsBox2d
 *
 *  Created by Steffen Itterheim on 17.09.10.
 *  Copyright 2010 Steffen Itterheim. All rights reserved.
 *
 */

#import "Box2D.h"

class ContactListener : public b2ContactListener
{
    
public:
	void BeginContact(b2Contact* contact);
	void EndContact(b2Contact* contact);
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);    
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    void BubbleGravityStart(b2Body* bodyA, b2Body* bodyB);
};
