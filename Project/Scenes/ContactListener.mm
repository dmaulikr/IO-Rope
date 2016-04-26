/*
 *  ContactListener.mm
 *  PhysicsBox2d
 *
 *  Created by Steffen Itterheim on 17.09.10.
 *  Copyright 2010 Steffen Itterheim. All rights reserved.
 *
 */

#import "ContactListener.h"
#import "Player.h"
#import "Bonus.h"
#import "StaticEnemies.h"


void ContactListener::BeginContact(b2Contact* contact)
{
    b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
    
    id userDataA = (id)bodyA->GetUserData();
    id userDataB = (id)bodyB->GetUserData();
    
    if ([userDataA isKindOfClass:[Bonus class]] && [userDataB isKindOfClass:[Player class]])
    {
        Bonus* bonus = (Bonus*)userDataA;
        [bonus contactedByPlayer];
    }
    if ([userDataA isKindOfClass:[StaticEnemies class]] && [userDataB isKindOfClass:[Player class]])
    {
        StaticEnemies* bonus = (StaticEnemies*)userDataA;
        Player* player = (Player*) userDataB;
        [bonus contactedByPlayer:player];
    }
}

void ContactListener::EndContact(b2Contact* contact)
{
  //  CCLOG(@"Contact END!!!!!!");
}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
}


