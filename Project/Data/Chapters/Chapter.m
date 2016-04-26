//
//  Chapter.m
//

#import "Chapter.h"

@implementation Chapter 

// Synthesize variables
@synthesize name = _name;
@synthesize number = _number;
@synthesize text = _text;

-(id)initWithName:(NSString*)name number:(int)number text:(NSString *)text {

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.name = name; 
        self.number = number;
        self.text = text;
    }
    return self;
}

- (void) dealloc {
    [_name release]; // FIX MEMORY LEAK
    [super dealloc];
}

@end