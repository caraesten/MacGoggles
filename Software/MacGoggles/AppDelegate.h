//
//  AppDelegate.h
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/25/12.
//

#import <Cocoa/Cocoa.h>
#import "GoggleWindow.h"
#import <Matatino/Matatino.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, MatatinoDelegate>
{
    NSImage *statusImage;
    Boolean isDisabled;
    Boolean isActive;
    Matatino *arduino;
}

-(void) releaseScreen;
-(void) showScreen;
-(IBAction)triggerScreen:(id)sender;
-(IBAction)disableScreen:(id)sender;

@property (retain) IBOutlet NSMenu *menuBar;

@property (assign) IBOutlet NSWindow *window;

@property (strong) NSStatusItem *statusItem;

@property (strong) GoggleWindow *mainWindow;

@property (assign) IBOutlet NSMenuItem *disable;


@end
