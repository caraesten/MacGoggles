//
//  GoggleWindow.m
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/26/12.
//

#import "GoggleWindow.h"

@implementation GoggleWindow

@synthesize konamiCode, buttonPresses,windowViewController;

-(id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen];
    if (self){
        // Konami code digits
        int codeDigits[11] = {36,0,11,124,123,124,123,125,125,126,126};
        NSNumber *code[11];
        // Create NSNumbers for all entries in Konami Code
        for (int i = 0; i < 11; i++){
            code[i] = [[NSNumber alloc] initWithInt:codeDigits[i]];
        }
        // Allocate Konami Code array with NSNumbers
        konamiCode = [[NSArray alloc] initWithObjects:code[0], code[1],code[2],code[3], code[4],code[5],code[6], code[7],code[8],code[9], code[10], nil];
        // Init the view controller for the Goggle display
        windowViewController = [[GoggleViewController alloc] initWithNibName:@"GoggleViewController" bundle:[NSBundle mainBundle]];
        
        // Hold button presses
        buttonPresses = [[NSMutableArray alloc] initWithCapacity:11];
        
        // Set the view to the GoggleViewController's View
        self.contentView = windowViewController.view;
        
        // Display everything
        [self setInitialFirstResponder:windowViewController.view];
        [self makeKeyWindow];
        [self display];
    }
    return self;
}

-(void) makeWindowViewFirstResponder
{
    [self makeFirstResponder:windowViewController.view];
}


// Clean up variables
-(void) doCleanup
{
    [windowViewController doCleanup];
    windowViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// Make sure it can recieve keypresses
-(BOOL)acceptsFirstResponder{
    return YES;
}
-(BOOL)canBecomeKeyWindow{
    return YES;
}

-(BOOL)becomeFirstResponder{
    NSLog(@"Becoming first responder...");
    return YES;
}

-(BOOL) resignFirstResponder{
    NSLog(@"Resigning first responder...");
    return YES;
}


// When the key's pressed down, check for Konami Code
-(void)keyDown:(NSEvent *)event
{
    NSLog(@"Down.");

    int code = [event keyCode];
    if ([buttonPresses count] == 11){
        [buttonPresses removeObjectAtIndex:10];
    }
    [buttonPresses insertObject:[[NSNumber alloc] initWithInt:code] atIndex:0];
    if ([buttonPresses isEqualToArray:konamiCode]){
        NSLog(@"Code worked!");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeScreen" object:self];
    }
    else {
        if ([buttonPresses count] == 11){
            NSLog(@"Current presses: %@", buttonPresses);
        }
    }
    
}

@end
