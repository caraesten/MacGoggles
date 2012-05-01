//
//  AppDelegate.m
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/25/12.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

@synthesize menuBar, statusItem, mainWindow, disable;

- (void)awakeFromNib
{
    // Start with system enabled
    isDisabled = NO;
    
    // Register for notifications for screen closing and resetting app
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(releaseScreen)
                                                 name:@"closeScreen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showScreen)
                                                 name:@"resetApp" object:nil];

    // Create item in status bar
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle mainBundle];
    //statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"beer" ofType:@"png"]];
    
    // Set the title to MacGoggles
    [statusItem setTitle:@"MacGoggles"];
    
    // Put it up there
    [statusItem setMenu:menuBar];
    
    // It can be highlighted
    [statusItem setHighlightMode:YES];
    
    // Allocate arduino library
    arduino = [[Matatino alloc] initWithDelegate:self];
    
    // Connect to the first item in the serial list (always the arduino on my comp)
    // (maybe change this to list under the menu bar at some point?)
    [arduino connect:[[arduino deviceNames] objectAtIndex:0] withBaud:B9600];
    
    // Cue into the system sleep notification
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self 
                                                           selector: @selector(handleSleep:) 
                                                               name: NSWorkspaceWillSleepNotification object: NULL];
}

// If the system is enabled, when it goes into sleep, show the lock screen
- (void) handleSleep: (id) sender
{
    if (!isDisabled){
        [self showScreen];
    }
}

// Launch the lock screen
-(IBAction)triggerScreen:(id)sender
{
    [self showScreen];
}

// Enable/disable the screen
-(IBAction)disableScreen:(id)sender
{
    if (!isDisabled){
        [disable setTitle:@"Enable"];
        isDisabled = YES;
    }
    else {
        [disable setTitle:@"Disable"];
        isDisabled = NO;
    }
}

// Do the actual showing of the screen
-(void)showScreen
{
    // Cleanup the main window, in case it's still up
    [mainWindow doCleanup];
    
    // Nil it out
    mainWindow = nil;
    
    int windowLevel;
    NSRect screenRect;
    
    // Try to capture display 
    // (point of no return, MAKE SURE THE ESCAPE CODE WORKS!!)
    if (CGDisplayCapture(kCGDirectMainDisplay) != kCGErrorSuccess){
        NSLog(@"Couldn't capture display");
    }
    
    // Get the window level
    windowLevel = CGShieldingWindowLevel();
    
    // Set screen size
    screenRect = [[NSScreen mainScreen] frame];

    // Allocate the Goggle Window class
    mainWindow = [[GoggleWindow alloc] initWithContentRect:screenRect
                                                 styleMask:NSBorderlessWindowMask
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO
                                                    screen: [NSScreen mainScreen]];
    
    // Put it on the front
    [mainWindow setLevel:windowLevel];
    
    // Make background black
    [mainWindow setBackgroundColor:[NSColor blackColor]
     ];
    
    // Bring it to the front
    [mainWindow makeKeyAndOrderFront:nil];

}

-(void)releaseScreen
{
    // Get rid of the screen
    [mainWindow orderOut:self];
    // Release it
    if (CGDisplayRelease(kCGDirectMainDisplay) != kCGErrorSuccess){
        NSLog(@"Release failed!");
    }
}

// Handle the recieved string from the Arduino
-(void)receivedString:(NSString *)rx
{
    // Set strings to compare to
    NSString *drunkReport = [NSString stringWithString:@"DLEVEL"];
    NSString *buttonOnReport = [NSString stringWithString:@"BREON"];
    NSString *warmedUpReport = [NSString stringWithString:@"BREWRM"];

    // Sanitize newlines (kept them in the serial communication bc it makes it readable
    NSString *rx_sane = [rx stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    // Check if it's reporting a breathalyzer level
    if([rx_sane length] >= 6 && [drunkReport isEqualToString:[rx_sane substringWithRange:NSMakeRange(0, 6)]]){
        // Split string into components
        NSArray *chunks = [rx_sane componentsSeparatedByString:@" "];
        
        // Allocate dictionary for data bundle
        NSMutableDictionary *u_data = [[NSMutableDictionary alloc] init];
        
        // Set the value of the breath reading
        [u_data setValue:[NSNumber numberWithInt:[[chunks objectAtIndex:1] intValue]] forKey:@"breathReading"];
        
        // Dispatch notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBreathalyzerStatus" object:self userInfo:u_data];
    }
    else if ([rx_sane length] >= 5 && [buttonOnReport isEqualToString:[rx_sane substringWithRange:NSMakeRange(0, 5)]]){
        // Dispatch button press
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonPressed" object:self userInfo:nil];
    }
    else if ([rx_sane length] >= 6 && [warmedUpReport isEqualToString:[rx_sane substringWithRange:NSMakeRange(0, 6)]]){
        // Dispatch blow ready (it's warm)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"blowReady" object:self userInfo:nil];
    }
    NSLog(@"Serial: %@", rx_sane);
    drunkReport = nil;
    buttonOnReport = nil;
    warmedUpReport = nil;
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    // Make sure to release the window before it quits, just in case...
    [mainWindow orderOut:self];
    if (CGDisplayRelease(kCGDirectMainDisplay) != kCGErrorSuccess){
        NSLog(@"Couldn't release display.");
    }
}
@end
