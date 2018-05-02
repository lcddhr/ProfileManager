//
//  MTOutlineView.m
//  MTProfileManager
//
//  Created by meitu on 2018/4/20.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import "MTOutlineView.h"


@interface MTOutlineView () <MTMenuDelegate>

@property (nonatomic, strong) NSMenuItem *refreshItem;
@property (nonatomic, strong) NSMenuItem *importItem;
@property (nonatomic, strong) NSMenuItem *showInFinderItem;
@property (nonatomic, strong) NSMenuItem *moveToTrashItem;
@property (nonatomic, strong) NSMenuItem *deleteItem;
@property (nonatomic, strong) NSMenuItem *exportItem;
@property (nonatomic, strong) NSMenuItem *exportCertificateItem;


@end
@implementation MTOutlineView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
        
    }
    
    return self;
}
- (void)awakeFromNib {
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}



//-(void)rightMouseDown:(NSEvent *)event {
//    NSLog(@"点击右键了");
////    NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
////    [self.mainMenu popUpMenuPositioningItem:nil atLocation:location inView:self];
//}

#pragma mark - MenuDelegate
- (void)menuWillOpen:(NSMenu *)menu {
    
    if (menu == self.itemMenu) {
        if (!self.refreshItem) {
            NSMenuItem *refreshItem = [[NSMenuItem alloc] initWithTitle:@"refresh" action:@selector(refreshAction:) keyEquivalent:@""];
            [refreshItem setTarget:self];
            [menu addItem:refreshItem];
            self.refreshItem = refreshItem;
        }

        
        if (!self.importItem) {
            NSMenuItem *importItem = [[NSMenuItem alloc] initWithTitle:@"import profile" action:@selector(importAction:) keyEquivalent:@""];
            [importItem setTarget:self];
            [menu addItem:importItem];
            self.importItem = importItem;
        }

    } else if (menu == self.mainMenu){
        
        if (!self.showInFinderItem) {
            NSMenuItem *showInFinderItem = [[NSMenuItem alloc] initWithTitle:@"show in finder" action:@selector(showInFinderAction:) keyEquivalent:@""];
            [showInFinderItem setTarget:self];
            [menu addItem:showInFinderItem];
            self.showInFinderItem = showInFinderItem;
        }
        
        if (!self.moveToTrashItem) {
            
            NSMenuItem *moveToTrashItem = [[NSMenuItem alloc] initWithTitle:@"move to trash" action:@selector(moveToTrashAction:) keyEquivalent:@""];
            [moveToTrashItem setTarget:self];
            [menu addItem:moveToTrashItem];
            self.moveToTrashItem = moveToTrashItem;
        }
        
        if (!self.deleteItem) {
            
            NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:@"delete" action:@selector(deleteAction:) keyEquivalent:@""];
            [deleteItem setTarget:self];
            [menu addItem:deleteItem];
            self.deleteItem = deleteItem;
        }

        
        if (!self.exportItem) {
            
            NSMenuItem *exportItem = [[NSMenuItem alloc] initWithTitle:@"export" action:@selector(exportAction:) keyEquivalent:@""];
            [exportItem setTarget:self];
            [menu addItem:exportItem];
            self.exportItem = exportItem;
        }
    } else if (menu == self.certificateMenu ) {
        
        if (!self.exportCertificateItem) {
            NSMenuItem *exportCertificateItem = [[NSMenuItem alloc] initWithTitle:@"export certificate" action:@selector(exportCertificateAction:) keyEquivalent:@""];
            [exportCertificateItem setTarget:self];
            [menu addItem:exportCertificateItem];
            self.exportCertificateItem = exportCertificateItem;
        }
    }
}

#pragma mark - Event
-(void)showInFinderAction:(NSMenuItem *)item {
    if (self.menuItemDelegate && [self.menuItemDelegate respondsToSelector:@selector(showInFinder)]) {
        [self.menuItemDelegate showInFinder];
    }
}

- (void)moveToTrashAction:(NSMenuItem *)item {
    if (self.menuItemDelegate && [self.menuItemDelegate respondsToSelector:@selector(moveToTrash)]) {
        [self.menuItemDelegate moveToTrash];
    }
}

- (void)exportAction:(NSMenuItem *)item {
    if (self.menuItemDelegate && [self.menuItemDelegate respondsToSelector:@selector(exportProfile)]) {
        [self.menuItemDelegate exportProfile];
    }
}

- (void)importAction:(NSMenuItem *)item {
    if (self.menuItemDelegate && [self.menuItemDelegate respondsToSelector:@selector(importProfile)]) {
        [self.menuItemDelegate importProfile];
    }
}

- (void)deleteAction:(NSMenuItem *)item{
    if (self.menuItemDelegate && [self.menuItemDelegate respondsToSelector:@selector(deleteProfile)]) {
        [self.menuItemDelegate deleteProfile];
    }
}

#pragma mark - Getter and Setter
-(MTMenu *)mainMenu {
    if (!_mainMenu) {
        _mainMenu = [[MTMenu alloc] init];
        _mainMenu.delegate = self;
    }
    return _mainMenu;
}

-(MTMenu *)itemMenu {
    if (!_itemMenu) {
        _itemMenu = [[MTMenu alloc] init];
        _itemMenu.delegate = self;
    }
    return _itemMenu;
}

-(MTMenu *)certificateMenu {
    if (!_certificateMenu) {
        _certificateMenu = [[MTMenu alloc] init];
        _certificateMenu.delegate = self;
    }
    return _certificateMenu;
}

@end
