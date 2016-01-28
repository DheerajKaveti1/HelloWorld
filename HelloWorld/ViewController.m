//
//  ViewController.m
//  HelloWorld
//
//  Created by Kaveti, Dheeraj on 1/15/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

#import "ViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "RATableViewCell.h"

@interface ViewController ()<RATreeViewDelegate, RATreeViewDataSource>

@property (weak, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) UIBarButtonItem *editButton;
@property (nonatomic, assign) int count;
@property (nonatomic ,assign) NSMutableArray *parentCheckArray;
@property (nonatomic , strong) NSMutableArray *allChilds;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadEBHDataWithLevel:2];
    [self getChildCount:_data[0]];
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [UIView new];
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [treeView reloadData];
    [treeView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    
    self.treeView = treeView;
    self.treeView.frame = self.view.bounds;
    self.treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:treeView atIndex:0];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"Things", nil);
    
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadEBHDataWithLevel:(int)Level{
    
  /*  RADataObject *bottler1 = [RADataObject dataObjectWithName:@"bottler 1" children:nil];
    RADataObject *bottler2 = [RADataObject dataObjectWithName:@"bottler 2" children:nil];
    RADataObject *bottler3 = [RADataObject dataObjectWithName:@"bottler 3" children:nil];
    RADataObject *bottler4 = [RADataObject dataObjectWithName:@"bottler 4" children:nil];
    
    RADataObject *bottler5 = [RADataObject dataObjectWithName:@"bottler 5" children:nil];
    RADataObject *bottler6 = [RADataObject dataObjectWithName:@"bottler 6" children:nil];
    RADataObject *bottler7 = [RADataObject dataObjectWithName:@"bottler 7" children:nil];
    RADataObject *bottler8 = [RADataObject dataObjectWithName:@"bottler 8" children:nil];
    
    RADataObject *bottler11 = [RADataObject dataObjectWithName:@"bottler 11" children:nil];
    RADataObject *bottler12 = [RADataObject dataObjectWithName:@"bottler 12" children:nil];
    RADataObject *bottler13 = [RADataObject dataObjectWithName:@"bottler 13" children:nil];
    RADataObject *bottler14 = [RADataObject dataObjectWithName:@"bottler 14" children:nil];
    
    RADataObject *bottler15 = [RADataObject dataObjectWithName:@"bottler 15" children:nil];
    RADataObject *bottler16 = [RADataObject dataObjectWithName:@"bottler 16" children:nil];
    RADataObject *bottler17 = [RADataObject dataObjectWithName:@"bottler 17" children:nil];
    RADataObject *bottler18 = [RADataObject dataObjectWithName:@"bottler 18" children:nil];
    
    RADataObject *EB4 = [RADataObject dataObjectWithName:@"EB4" children:[NSArray arrayWithObjects:bottler1, bottler2, bottler3, bottler4, nil]];
    RADataObject *EB41 = [RADataObject dataObjectWithName:@"EB41" children:[NSArray arrayWithObjects:bottler5, bottler6, bottler7, bottler8, nil]];
    RADataObject *EB42 = [RADataObject dataObjectWithName:@"EB42" children:[NSArray arrayWithObjects:bottler11, bottler12, bottler13, bottler14, nil]];
    RADataObject *EB43 = [RADataObject dataObjectWithName:@"EB43" children:[NSArray arrayWithObjects:bottler15, bottler16, bottler17, bottler18, nil]];
    
    RADataObject *EB31 = [RADataObject dataObjectWithName:@"EB31" children:[NSArray arrayWithObjects:EB41, EB42, nil]];
    RADataObject *EB32 = [RADataObject dataObjectWithName:@"EB32" children:[NSArray arrayWithObjects:EB4,EB43, nil]];

    RADataObject *EB22 = [RADataObject dataObjectWithName:@"EB22" children:[NSArray arrayWithObjects:EB31, nil]];
    RADataObject *EB23 = [RADataObject dataObjectWithName:@"EB22" children:[NSArray arrayWithObjects:EB32, nil]];
    
    RADataObject *EB1 = [RADataObject dataObjectWithName:@"EB1" children:[NSArray arrayWithObjects:EB22,EB23, nil]];
    
    self.data = [NSArray arrayWithObjects:EB1, nil];
   */
}




-(int)getChildCount:(RADataObject*)dataObj{
    
    if (dataObj.children) {
        _count++;
        if (dataObj.children.count) {
            [self getChildCount:dataObj.children[0]];
        }else{
            return _count;
        }
    }
    return _count;
}


#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 44;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return YES;
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
    [cell setAdditionButtonHidden:NO animated:YES];
}

- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
    RATableViewCell *cell = (RATableViewCell *)[treeView cellForItem:item];
    [cell setAdditionButtonHidden:NO animated:YES];
}

- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    RADataObject *parent = [self.treeView parentForItem:item];
    NSInteger index = 0;
    
    if (parent == nil) {
        index = [self.data indexOfObject:item];
        NSMutableArray *children = [self.data mutableCopy];
        [children removeObject:item];
        self.data = [children copy];
        
    } else {
        index = [parent.children indexOfObject:item];
        [parent removeChild:item];
    }
    
    [self.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
    if (parent) {
        [self.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
    }
}


#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    RADataObject *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    NSInteger numberOfChildren = [dataObject.children count];
    NSString *detailText = [NSString localizedStringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataObject.name detailText:detailText level:level additionButtonHidden:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        NSLog(@"%lu",(unsigned long)[self.data indexOfObject:dataObject]);
         UIButton *button = sender;
         [dataObject selectAllChilds:!button.selected];
         [self reloadParent:dataObject];
         [self.treeView reloadRows];
        if (![weakSelf.treeView isCellForItemExpanded:dataObject] || weakSelf.treeView.isEditing) {
            return;
        }
    };
    
    if (dataObject.isSelected) {
        cell.additionButton.selected = dataObject.isSelected;
    }
    else{
        cell.additionButton.selected = NO;
    }
    return cell;
}

-(void)reloadParent:(RADataObject*)dataObject{
    
    RADataObject *parent = [self.treeView parentForItem:dataObject];
    if (parent) {
        if (![[parent.children valueForKey:@"isSelected"] containsObject:@0]) {
            parent.isSelected = YES;
        }else{
            parent.isSelected = NO;
        }
        [self reloadParent:parent];
    }
}


-(void)checkAllChecked:(RADataObject*)dataObject isChild:(BOOL)child{
    
    RADataObject *parent = [self.treeView parentForItem:dataObject];
    if (parent) {
    if (child) {
        _parentCheckArray = [parent.children valueForKey:@"isSelected"];
        if ([_parentCheckArray containsObject:@0]) {
            parent.isSelected = NO;
            [self checkAllChecked:parent isChild:NO];
        }
    }else{
        parent.isSelected = dataObject.isSelected;
        [self checkAllChecked:parent isChild:NO];
    }
  }
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}

- (IBAction)generateBottlers:(id)sender {
    NSMutableArray *array = [NSMutableArray array];
    for (RADataObject *treeBrances in self.data) {
        [array addObjectsFromArray: [self getAllChilds:treeBrances]];
    }
    NSSet *set = [NSSet setWithArray:array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isLeafNode == YES AND SELF.isSelected == YES "];
    NSArray *array1 = [[set allObjects] filteredArrayUsingPredicate:predicate];
    NSLog(@"%@",array1.description);
}


-(NSMutableArray*)getAllChilds:(RADataObject *)dataObject{
    if (!_allChilds) {
        _allChilds = [NSMutableArray array];
    }
    if (dataObject.children) {
        if (dataObject.children.count) {
            for (int i = 0; i < dataObject.children.count; i++) {
                RADataObject *dataObj = dataObject.children[i];
                [self getAllChilds:dataObj];
            }
        }
        else{
            [_allChilds addObject:dataObject];
        }
    }
    return _allChilds;
}

@end
