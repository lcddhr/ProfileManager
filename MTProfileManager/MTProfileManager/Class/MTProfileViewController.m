//
//  MTProfileViewController.m
//  MTProfileManager
//
//  Created by meitu on 2018/4/19.
//  Copyright © 2018年 lcd. All rights reserved.
//

#import "MTProfileViewController.h"
#import "MTProfileManager.h"
#import "MTOutlineView.h"
#import "MTTreeNodeModel.h"
#import "NSData+Base64.h"
#import "MTMenu.h"
#import "MTAlertView.h"
#import "MTFileManager.h"


@interface MTProfileViewController () <NSOutlineViewDelegate, NSOutlineViewDataSource,NSMenuDelegate, MTMenuDelegate, MTOutlineViewDelegate>
@property (weak) IBOutlet MTOutlineView *treeView;
@property (nonatomic, copy) NSArray *profileDatas;
@property (nonatomic, strong) MTTreeNodeModel *treeModel;
@property (nonatomic, strong) MTProfileManager *profileManager;
@property (atomic, strong) NSMutableArray *uuids;
@end

@implementation MTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 加载本地profile数据
    [self setupData];

    // 2. 配置 tree view
    [self configTreeView];
}

- (void)setupData {

    self.profileManager = [[MTProfileManager alloc] init];
    [self updateProfileData];
}

- (void)configTreeView {
    
    [self.treeView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
    [self.treeView sizeToFit];
    self.treeView.menuItemDelegate = self;
    [self.treeView reloadData];
}

#pragma mark - NSOutlineViewDelegate
-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    MTTreeNodeModel *rootNode = nil;
    if (item) {
        rootNode = item;
    } else {
        rootNode = self.treeModel;
    }
    return rootNode.childNodes.count;
}

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    
    MTTreeNodeModel *rootNode = item;
    return rootNode.childNodes.count > 0;
}

-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    
    MTTreeNodeModel *rootNode = nil;
    if (item) {
        rootNode = item;
    } else {
        rootNode = self.treeModel;
    }
    return rootNode.childNodes[index];
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSTextFieldCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if ([outlineView parentForItem:item] == nil) {
        
        [cell setMenu:self.treeView.mainMenu];
        
    }else{
        MTTreeNodeModel *node = item;
        MTTreeNodeModel *parentNode = [outlineView parentForItem:item];
        if ([parentNode.name isEqualToString:@"DeveloperCertificates"]) {
         
            [cell setMenu:self.treeView.certificateMenu];
        }
        else if ( node.childNodes.count > 0){
            [cell setMenu:nil];
        }else{
         [cell setMenu:self.treeView.itemMenu];
        }
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    
    MTTreeNodeModel *treeModel = item ? : self.treeModel;
    
    static NSString *kColumnIdentifierKey = @"key";
    static NSString *kColumnIdentifierType = @"type";
    
    if ([[tableColumn identifier] isEqualToString:kColumnIdentifierKey]) {
        
        return treeModel.name;
    }
    else if([[tableColumn identifier] isEqualToString:kColumnIdentifierType]){
     
        return treeModel.type;
    }
    else {
        return treeModel.detail;
    }
}

-(CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 20;
}

#pragma mark - MTOutlineViewDelegate
-(void)showInFinder {
   
    MTTreeNodeModel *selectNode = [self selectTreeNode];
    if (!selectNode) {
        return;
    }
    if (selectNode.filePath.length > 0) {
        [[NSWorkspace sharedWorkspace] selectFile:selectNode.filePath inFileViewerRootedAtPath:@""];
    }
}

-(void)exportProfile {
    MTTreeNodeModel *selectNode = [self selectTreeNode];
    if (!selectNode) {
        return;
    }
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[@"mobileprovision",@"provisionprofile"];
    savePanel.nameFieldStringValue = selectNode.name;
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        
        NSString *savePath = savePanel.URL.path;
        if (result == NSModalResponseOK) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
            }
            [[NSFileManager defaultManager] copyItemAtPath:selectNode.filePath toPath:savePath error:nil];
        }
    }];
}

- (void)importProfile {
    
    NSError *error = nil;
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    [openPanel setAllowedFileTypes:@[@"mobileprovision",@"MOBILEPROVISION"]];
    
    if ([openPanel runModal] == NSModalResponseOK) {
        NSString *path = [[[openPanel URLs] objectAtIndex:0] path];
        NSString *toPath = [NSString stringWithFormat:@"%@%@",[[MTFileManager sharedInstance]profileDirectory], [path lastPathComponent]];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:&error];
    }
    
    if (error) {
        MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"出错了" message:[error description] style:NSAlertStyleWarning];
        [alertView addButtonWithTitle:@"OK"];
        [alertView show:self.view.window];
    } else {
            [self updateProfileData];
            [self.treeView reloadData];
    }
}

-(void)deleteProfile {
    
    MTTreeNodeModel *selectNode = [self selectTreeNode];
    __block NSInteger index = [self.treeView clickedRow];
    MTAlertView *alert = [[MTAlertView alloc] initWithTitle:@"Confirm Delete Operation" message:@"Delete this profile,can't rollback" style:NSAlertStyleCritical];
    [alert addButtonWithTitle:@"OK" handler:^(MTAlertViewItem *item) {
        
        [self.treeView beginUpdates];
        [self.treeView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index]  inParent:nil withAnimation:NSTableViewAnimationEffectFade];
        [self.treeView endUpdates];
        
        if (self.treeModel.childNodes > 0) {
            [self.treeModel.childNodes removeObjectAtIndex:index];
        }
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:selectNode.filePath error:&error];
        if (error) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:[error description]];
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
        }
    }];
    [alert addButtonWithTitle:@"cancle"];
    [alert show:self.view.window];
}

-(void)moveToTrash {
    MTTreeNodeModel *selectNode = [self selectTreeNode];
    __block NSInteger index = [self.treeView clickedRow];
    MTAlertView *alertView = [[MTAlertView alloc] initWithTitle:@"Warning" message:@"move item to trash ?" style:NSAlertStyleWarning];
    [alertView addButtonWithTitle:@"OK" handler:^(MTAlertViewItem *item) {
        
        if (!selectNode) {
            return;
        }
        [self.treeView beginUpdates];
        [self.treeView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:nil withAnimation:NSTableViewAnimationEffectFade];
        [self.treeView endUpdates];
        
        if (self.treeModel.childNodes > 0) {
            [self.treeModel.childNodes removeObjectAtIndex:index];
        }
        [[MTFileManager sharedInstance] deleteFile:selectNode.filePath option:NO];
    }];
    [alertView addButtonWithTitle:@"cancle"];
    [alertView show:self.view.window];
}

#pragma mark - Private Method
- (MTTreeNodeModel *)selectTreeNode {
    
    NSInteger index = [self.treeView clickedRow];
    if (index == -1) {
        return nil;
    }
    
    MTTreeNodeModel *node = [self.treeView itemAtRow:index];
    return node;
}

- (void)updateProfileData {
    self.profileDatas = [self.profileManager loadProfileData];
    
    // 测试数据
    self.treeModel = [[MTTreeNodeModel alloc] init];
    
    [self.profileDatas enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *uuid = item[@"UUID"];
        NSString *type = item[@"Name"];
        NSString *filePath = item[@"filePath"];
        NSDate *expiration = [item objectForKey:@"ExpirationDate"];
        NSString *detail  =  [[NSDate date] compare:expiration] == NSOrderedDescending ?@"expired":@"valid";

        // 1级目录
        MTTreeNodeModel *rootNode = [[MTTreeNodeModel alloc] init];
        rootNode.name = uuid;
        rootNode.type = type;
        rootNode.detail = detail;
        rootNode.filePath = filePath;
        [self.treeModel.childNodes addObject:rootNode];
        
        
        NSArray *allKeys = [item allKeys];
        for (NSString *key in allKeys) {
            id value = item[key];
            if ([value isKindOfClass:[NSString class]]) {
                MTTreeNodeModel *node = [[MTTreeNodeModel alloc] init];
                node.name = key;
                node.type = @"String";
                node.detail = value;
                [rootNode.childNodes addObject:node];
            }
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                value = (NSDictionary *)value;
                MTTreeNodeModel *node = [[MTTreeNodeModel alloc] init];
                node.name = key;
                node.type = @"Dictionary";
                node.detail = [NSString stringWithFormat:@"%lu items",[value count]];
                [rootNode.childNodes addObject:node];
            }
            
            if ([value isKindOfClass:[NSArray class]]) {
                value = (NSArray *)value;
                MTTreeNodeModel *node = [[MTTreeNodeModel alloc] init];
                node.name = key;
                node.type = @"Array";
                node.detail = [NSString stringWithFormat:@"%lu items",[value count]];
                [rootNode.childNodes addObject:node];
                
                if ([key isEqualToString:@"ProvisionedDevices"] || [key isEqualToString:@"ApplicationIdentifierPrefix"] || [key isEqualToString:@"Platform"] || [key isEqualToString:@"TeamIdentifier"]) {
                    for (NSInteger i = 0; i < [value count]; i++) {
                        MTTreeNodeModel *deviceNode = [[MTTreeNodeModel alloc] init];
                        deviceNode.name = [NSString stringWithFormat:@"%@",@(i)];
                        deviceNode.type = @"String";
                        deviceNode.detail = value[i];
                        [node.childNodes addObject:deviceNode];
                    }
                }
                
                if ([key isEqualToString:@"DeveloperCertificates"]) {
                    for (NSInteger i = 0; i < [value count]; i++) {
                        MTTreeNodeModel *certificatesNode = [[MTTreeNodeModel alloc] init];
                        NSData *data = value[i];
                        NSDictionary *parseData = [self.profileManager parseCertificate:data];
                        certificatesNode.name = parseData[@"summary"];
                        certificatesNode.type = @".cer";
                        certificatesNode.detail = [data mt_base64EncodeString];
                        [node.childNodes addObject:certificatesNode];
                    }
                }
            }
            
            if ([value isKindOfClass:[NSNumber class]]) {
                value = (NSNumber *)value;
                MTTreeNodeModel *node = [[MTTreeNodeModel alloc] init];
                node.name = key;
                node.type = @"Number";
                node.detail =[NSString stringWithFormat:@"%@",value];
                [rootNode.childNodes addObject:node];
            }
            
            if ([key isEqualToString:@"CreationDate"] || [key isEqualToString:@"ExpirationDate"]) {
                MTTreeNodeModel *node = [[MTTreeNodeModel alloc] init];
                node.name = key;
                node.type = @"Date";
                node.detail =[NSString stringWithFormat:@"%@",value];
                [rootNode.childNodes addObject:node];
            }
        }
    }];
}

#pragma mark - Getter and Setter

@end
