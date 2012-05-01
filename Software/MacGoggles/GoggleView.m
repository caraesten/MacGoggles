//
//  GoggleView.m
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoggleView.h"

@implementation GoggleView

@synthesize tryAgain,systemStatus, barView;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSRect screenRect = [[NSScreen mainScreen] frame];
        barView = [[BarView alloc] initWithFrame:NSMakeRect(20, screenRect.size.height /2, 5, screenRect.size.height / 8)];
        systemStatus = [[NSTextField alloc] initWithFrame:NSMakeRect(20, screenRect.size.height - (screenRect.size.height / 10) - 100, screenRect.size.width / 1.5, screenRect.size.height/10)];
        [systemStatus setEditable:NO];
        [systemStatus setFont:[NSFont fontWithName:@"Helvetica" size:30]];
        [systemStatus setStringValue:@"Press the button"];
        [systemStatus setBackgroundColor:[NSColor clearColor]];
        [systemStatus setBezeled:NO];
        [systemStatus setSelectable:NO];
        tryAgain = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 100, 400, 50)];
        [tryAgain setEditable:NO];
        [tryAgain setFont:[NSFont fontWithName:@"Helvetica" size:24]];
        [tryAgain setStringValue:@""];
        [tryAgain setBackgroundColor:[NSColor clearColor]];
        [tryAgain setBezeled:NO];
        [tryAgain setSelectable:NO];
        [self addSubview:tryAgain];
        [self addSubview:systemStatus];
        [self addSubview:barView];
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
    [systemStatus setStringValue:@"Blow into breathalyzer"];
    [systemStatus setTextColor:[NSColor redColor]];
}

- (void)updateBreathalyzerStatus: (NSNotification *) notificationObj
{
    NSLog(@"Updating breathalyzer status");
    NSRect screenRect = [[NSScreen mainScreen] frame];
    int alcoholReading = [[[notificationObj userInfo] objectForKey:@"breathReading"] intValue];
    NSLog(@"Breath reading is %d", alcoholReading);
    int newWidth = (screenRect.size.width * 0.90) * ((float) alcoholReading / 1024);
    NSLog(@"New width: %d", newWidth);
    [[barView animator] setFrameSize:NSMakeSize(newWidth, barView.frame.size.height)];
    if (alcoholReading > 600){
        [systemStatus setStringValue:@"You're completely wasted. Go drink some water."];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendResetNotification:) userInfo:nil repeats:NO];
    }
    else if (alcoholReading > 450){
        [systemStatus setStringValue:@"You're kinda tipsy. Type in the secret code. If you can remember it."];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendResetNotification:) userInfo:nil repeats:NO];    }
    else {
        // Sober!
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeScreen" object:self];
    }
}
 -(void)doCleanup
{
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
