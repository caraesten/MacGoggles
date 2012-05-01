//
//  GoggleViewController.m
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/28/12.
//

#import "GoggleViewController.h"

@implementation GoggleViewController

@synthesize tryAgain,systemStatus, barView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Get screen size
        NSRect screenRect = [[NSScreen mainScreen] frame];
        
        // Allocate the bar-graph
        barView = [[BarView alloc] initWithFrame:NSMakeRect(20, screenRect.size.height /2, 0, screenRect.size.height / 8)];
        
        // Make both text-fields non-selectable
        [systemStatus setSelectable:NO];
        [tryAgain setSelectable:NO];
        
        // Add the view to the hierarchy
        [self.view addSubview:barView];
        
        // Register for all arduino notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(readyForBlow:)
                                                     name:@"blowReady" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateBreathalyzerStatus:)
                                                     name:@"updateBreathalyzerStatus" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(warmingUp:)
                                                     name:@"buttonPressed" object:nil];
    }    
    return self;
}

- (void)warmingUp: (NSNotification *) notificationObj
{
    [systemStatus setStringValue:@"Warming Up..."];
}

- (void)readyForBlow: (NSNotification *) notificationObj
{
    // Alert user that the breathalyzer is ready for input
    [systemStatus setStringValue:@"Press button again, then..."];
    [tryAgain setStringValue:@"Blow into breathalyzer"];
    [systemStatus setTextColor:[NSColor redColor]];
    NSBeep();
}

- (void)updateBreathalyzerStatus: (NSNotification *) notificationObj
{
    NSLog(@"Updating breathalyzer status");
    // Get screen size
    NSRect screenRect = [[NSScreen mainScreen] frame];
    
    // Show legend
    legend = [[BarLegendView alloc] initWithFrame:NSMakeRect(20, screenRect.size.height /2, screenRect.size.width * 0.90, screenRect.size.height / 8)];
    
    // Add legend to subview
    [self.view addSubview:legend];
    
    // Grab alcohol reading from dictionary
    int alcoholReading = [[[notificationObj userInfo] objectForKey:@"breathReading"] intValue];
    NSLog(@"Breath reading is %d", alcoholReading);
    
    // Get the width of the barView
    int newWidth = (screenRect.size.width * 0.90) * ((float) alcoholReading / 1023);
    NSLog(@"New width: %d", newWidth);
    
    // Change color
    [barView setAlcoholForBackground:alcoholReading];
    
    // Start animation group
    [NSAnimationContext beginGrouping];
    
    // Set the animation duration to a second and a half
    [[NSAnimationContext currentContext] setDuration:1.5f];
    
    // Change size
    [[barView animator] setFrameSize:NSMakeSize(newWidth, barView.frame.size.height)];
    [NSAnimationContext endGrouping];
    
    if (alcoholReading > 600){
        // Very drunk
        [systemStatus setStringValue:@"You're completely wasted."];
        [tryAgain setStringValue:@"Go drink some water."];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendResetNotification:) userInfo:nil repeats:NO];
        // Clear after a couple of seconds
    }
    else if (alcoholReading > 400){
        // Less drunk
        [systemStatus setStringValue:@"You're kinda tipsy."];
        [tryAgain setStringValue:@"Type in the secret code. If you can remember it."];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendResetNotification:) userInfo:nil repeats:NO];    }
    else {
        // Sober!
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeScreen" object:self];
        // No message necessary, just kill screen
    }
}
-(void)doCleanup
{
    legend = nil;
    barView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)sendResetNotification: (id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetApp" object:self];
}

- (void)drawRect:(NSRect)dirtyRect
{
}

-(BOOL)acceptsFirstResponder{
    return YES;
}
-(BOOL)canBecomeKeyView {
    return YES;
}

-(BOOL)becomeFirstResponder{
    return YES;
}

-(BOOL) resignFirstResponder{
    return YES;
}

-(void) keyDown:(NSEvent *)theEvent{
    [super keyDown:theEvent];
}


@end
