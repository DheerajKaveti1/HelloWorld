//
//  NewViewController.m
//  HelloWorld
//
//  Created by Kaveti, Dheeraj on 1/15/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

#import "NewViewController.h"
#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "DPSUtilities.h"
#import "DPSBottler.h"
#import "EBHObject.h"
#import "RADataObject.h"
#define DB_FILE_NAME    @"/DPSBCMyDay.sqlite"
#define QUOTE_STRING_ORIGINAL   @"'"
#define QUOTE_STRING_REPLACED   @"<SQ>"

@interface NewViewController ()
@property(nonatomic,strong) NSMutableArray *eb1rray;
@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    NSString* docsPath  = [dirPaths lastObject];
    NSString *dbFileDirPath = [docsPath stringByAppendingPathComponent:DB_FILE_NAME];
    
    NSLog(@"DB Path: %@", dbFileDirPath);
    
    _databaseQ  = [FMDatabaseQueue databaseQueueWithPath:dbFileDirPath];
    _database   = [FMDatabase databaseWithPath:dbFileDirPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NewViewController*)sharedInstance {
    static NewViewController*   selfInstance;
    if (!selfInstance) {
        selfInstance    = [[NewViewController alloc] init];
    }
    
    return selfInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask,
                                                                YES);
        NSString* docsPath  = [dirPaths lastObject];
        NSString *dbFileDirPath = [docsPath stringByAppendingPathComponent:DB_FILE_NAME];
        
        NSLog(@"DB Path: %@", dbFileDirPath);
        
        _databaseQ  = [FMDatabaseQueue databaseQueueWithPath:dbFileDirPath];
        _database   = [FMDatabase databaseWithPath:dbFileDirPath];
    }
    return self;
}

-(void)loadBottlers{
    
    NSString* serviceURL  = @"https://dl.dropboxusercontent.com/u/160991568/Bottler.json";
    // = [NSString stringWithFormat:@"%@/bcmyday/OperationContract/BCService.svc/GetPromotionsByRegionID?regionid=%ld&mdate=%@", [self getServerURL], (unsigned long)regionObj.nodeId, lastUpdatedtime];
    NSURL *URL = [NSURL URLWithString:serviceURL];
    NSData* data = [NSData dataWithContentsOfURL:
                    URL];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization  JSONObjectWithData:data options:kNilOptions error:&error];

            [self addBottlers:[json objectForKey:@"Bottler"]];
        }



- (void)loadPromotionsForRegion{
    NSString* serviceURL  = @"https://dl.dropboxusercontent.com/u/160991568/BottlerHierarchyData.json";
    // = [NSString stringWithFormat:@"%@/bcmyday/OperationContract/BCService.svc/GetPromotionsByRegionID?regionid=%ld&mdate=%@", [self getServerURL], (unsigned long)regionObj.nodeId, lastUpdatedtime];
    NSURL *URL = [NSURL URLWithString:serviceURL];
    NSData* data = [NSData dataWithContentsOfURL:
                    URL];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization  JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *array = [[json valueForKeyPath:@"BottlerHierarchyData"]allKeys];
   
    for (NSString *key in array) {
        if ([key containsString:@"EBH"]) {
            [self addEBH:[[json valueForKeyPath:@"BottlerHierarchyData"] valueForKeyPath:key] nodeType:key];
        }
        
    }
}

- (void)addEBH:(NSArray*)itemsList nodeType:(NSString*)nodeType{
    BOOL tableExists    = [self checkIfTableExists:@"BCEBH_HIER_MSTER"];
    [_databaseQ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (!tableExists) {
            if (![db executeUpdate:@"CREATE TABLE BCEBH_HIER_MSTER (NODE_ID INTEGER NOT NULL,EB_NAME TEXT NOT NULL,BCNODE_ID TEXT NOT NULL, NODE_TYPE TEXT NOT NULL, NODE_DESCRIPTION TEXT NOT NULL, PARENT_NODE_ID INTEGER, IS_ACTIVE INTEGER, UPDATE_TIME TIMESTAMP)"]) {
                NSLog(@"Failed to create PRIORITY_EXECUTION table: Error: %@", db.lastErrorMessage);
                return;
            };
        }else {
            
            if (itemsList.count>0) {
                
                NSArray *idsList = [itemsList valueForKeyPath:@"@distinctUnionOfObjects.BCNodeID"];
                NSString* query = [NSString stringWithFormat:@"DELETE FROM BCEBH_HIER_MSTER WHERE BCNODE_ID IN ('%@') ", [self getJoinString:idsList]];
                if (![db executeUpdate:query]) {
                    NSLog(@"Failed to delete records in PRIORITY_EXECUTION table: Error: %@", db.lastErrorMessage);
                }else {
                    NSLog(@"%d records deleted in PRIORITY_EXECUTION table.", db.changes);
                }
            }
        }
        
        for (NSDictionary* itemDict in itemsList) {
            
            NSString *EBNAME = [self encodeString:[itemDict objectForKey:@"EBNAME"]];
            if (![db executeUpdate:[NSString stringWithFormat:@"INSERT INTO BCEBH_HIER_MSTER (NODE_ID, BCNODE_ID, NODE_TYPE, NODE_DESCRIPTION,PARENT_NODE_ID, IS_ACTIVE,UPDATE_TIME ,EB_NAME) VALUES ('%ld', '%@', '%@', '%@', '%ld','%ld','%@' , '%@')", (long)[DPSUtilities integerFromString:[itemDict objectForKey:@"EBID"]], [itemDict objectForKey:@"BCNodeID"],nodeType,nodeType,(long)[DPSUtilities integerFromString:[itemDict objectForKey:@"PARENT"]],(long)[DPSUtilities integerFromString:[itemDict objectForKey:@"Active"]],[DPSUtilities todayString],EBNAME]]) {
                NSLog(@"Failed to insert a record into PRIORITY_EXECUTION table: Priority ID: %@ :: Error: %@", [itemDict objectForKey:@"PriorityID"], db.lastErrorMessage);
            }
        }
    }];
}

- (EBHObject*)getEBHWithId:(NSInteger)EbId nodeType:(NSString*)nodeType {
    if (![self checkIfTableExists:@"BCEBH_HIER_MSTER"]) {
        NSLog(@"BCEBH_HIER_MSTER table doesn't exist");
        return nil;
    };
    
    if (![_database open]) {
        NSLog(@"Failed to open the database. :: Error: %@", _database.lastErrorMessage);
        return nil;
    }
    
    EBHObject* ebhObject;
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM BCEBH_HIER_MSTER WHERE IS_ACTIVE=1 AND NODE_TYPE = '%@' AND NODE_ID = '%ld'", nodeType,(long)EbId];
    FMResultSet* rs = [_database executeQuery:query];
    while ([rs next]) {
        ebhObject  = [self createEBH:rs];
    }
    
    [rs close];
    [_database close];
    
    return ebhObject;
}

- (NSArray*)getAllEBH:(NSString*)nodeType {
    if (![self checkIfTableExists:@"BCEBH_HIER_MSTER"]) {
        NSLog(@"BCEBH_HIER_MSTER table doesn't exist");
        return nil;
    };
    
    if (![_database open]) {
        NSLog(@"Failed to open the database. :: Error: %@", _database.lastErrorMessage);
        return nil;
    }
    
    NSMutableDictionary* resultsDict   = [[NSMutableDictionary alloc] init];
    
    FMResultSet* rs = [_database executeQuery:@"SELECT * FROM BCEBH_HIER_MSTER WHERE IS_ACTIVE=1 AND NODE_TYPE = '%@' ", nodeType];
    while ([rs next]) {
        EBHObject* ebhObject  = [self createEBH:rs];
        [resultsDict setObject:ebhObject forKey:[DPSUtilities stringFromInteger:ebhObject.EBID]];
    }
    
    [rs close];
    [_database close];
    
    return [resultsDict allValues];
}
- (EBHObject*)createEBH:(FMResultSet*)rs {
    EBHObject* EBHObj   = [[EBHObject alloc] init];
    EBHObj.EBID         = [rs intForColumnIndex:0];
    EBHObj.EBName = [self decodeString:[rs stringForColumnIndex:1]];
    EBHObj.BCNodeId  = [rs stringForColumnIndex:2];
    EBHObj.nodeType =  [rs stringForColumnIndex:3];
    EBHObj.nodeDesc = [rs stringForColumnIndex:4];
    EBHObj.parentId         = [rs intForColumnIndex:5];
    EBHObj.isActive =  [rs intForColumnIndex:6];
    return EBHObj;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)checkIfTableExists:(NSString*)tableName {
    if (![_database open]) {
        NSLog(@"Failed to open the database. :: Error: %@", _database.lastErrorMessage);
        return NO;
    }
    
    BOOL result = NO;
    FMResultSet* rs = [_database executeQuery:[NSString stringWithFormat:@"SELECT name from sqlite_master WHERE type='table' AND name='%@'", tableName]];
    if ([rs next]) {
        result  = YES;
    }
    
    [rs close];
    [_database close];
    
    return result;
}

- (NSString*)getJoinString:(NSArray*)idsList {
    NSString*   joinString =  [idsList componentsJoinedByString:@","];
    joinString  = [joinString stringByReplacingOccurrencesOfString:@"," withString:@"','"];
    return joinString;
}

- (void)addBottlers:(NSArray*)itemsList {
    BOOL tableExists    = [self checkIfTableExists:@"BOTTLERS_MASTER"];
    [_databaseQ inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (!tableExists) {
            if (![db executeUpdate:@"CREATE TABLE BOTTLERS_MASTER (BOTTLER_ID INTEGER NOT NULL PRIMARY KEY, BC_BOTTLER_ID TEXT, BOTTLER_NAME TEXT, CHANNEL_ID TEXT, STATUS_ID INTEGER, BCREGION_ID INTEGER, ADDRESS TEXT, CITY TEXT, STATE TEXT, POSTAL_CODE TEXT, COUNTRY TEXT, EMAIL TEXT, PHONE_NUMBER TEXT, LONGITUDE TEXT, LATITUDE TEXT, IS_ACTIVE INTEGER, UPDATE_TIME TIMESTAMP , EBID INTEGER)"]) {
                NSLog(@"Failed to create BOTTLERS_MASTER table: Error: %@", db.lastErrorMessage);
                return;
            }
        }else {
            //deleting the previous rows
            NSArray *idsList = [itemsList valueForKeyPath:@"@distinctUnionOfObjects.BottlerID"];
            NSString* query = [NSString stringWithFormat:@"DELETE FROM BOTTLERS_MASTER WHERE BOTTLER_ID IN (%@)", [idsList componentsJoinedByString:@","]];
            if (![db executeUpdate:query]) {
                NSLog(@"Failed to delete records in BOTTLERS_MASTER table: Error: %@", db.lastErrorMessage);
            }else {
                NSLog(@"%d records deleted in BOTTLERS_MASTER table.", db.changes);
            }
        }
        
        for (NSDictionary* itemDict in itemsList) {
            //changing ''' with 'QUOTE_STRING_REPLACED' as DB insert has issue with '''
            NSString* bottlerName   = [itemDict objectForKey:@"BottlerName"];
            
            
            if (![db executeUpdate:[NSString stringWithFormat:@"INSERT INTO BOTTLERS_MASTER (BOTTLER_ID, BC_BOTTLER_ID, BOTTLER_NAME, CHANNEL_ID, STATUS_ID, BCREGION_ID, ADDRESS, CITY, STATE, POSTAL_CODE, COUNTRY, EMAIL, PHONE_NUMBER, LONGITUDE, LATITUDE, IS_ACTIVE, UPDATE_TIME, EBID) VALUES ('%d', '%d', '%@', '%@', '%d', '%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%f', '%f', '%d', '%@' ,'%d')", [DPSUtilities integerFromString:[itemDict objectForKey:@"BottlerID"]], [DPSUtilities integerFromString:[itemDict objectForKey:@"SAPBottlerID"]], bottlerName, [itemDict objectForKey:@"ChannelID"], [DPSUtilities integerFromString:[itemDict objectForKey:@"StatusID"]], [DPSUtilities integerFromString:[itemDict objectForKey:@"BCRegionID"]], [itemDict objectForKey:@"Address"], [itemDict objectForKey:@"City"], [itemDict objectForKey:@"State"], [itemDict objectForKey:@"PostalCode"], [itemDict objectForKey:@"Country"], [itemDict objectForKey:@"Email"], [itemDict objectForKey:@"PhoneNumber"], [DPSUtilities doubleFromString:[itemDict objectForKey:@"GeoLongitude"]], [DPSUtilities doubleFromString:[itemDict objectForKey:@"GeoLatitude"]], [DPSUtilities integerFromString:[itemDict objectForKey:@"IsActive"]], [DPSUtilities todayString] ,[DPSUtilities integerFromString:[itemDict objectForKey:@"EBID"]] ]]) {
                NSLog(@"Failed to insert a record into BOTTLERS_MASTER table: Bottler ID: %@ :: Error: %@", [itemDict objectForKey:@"BottlerID"], db.lastErrorMessage);
            }
        }
    }];
}

- (NSArray*)getAllBottlers {
    if (![self checkIfTableExists:@"BOTTLERS_MASTER"]) {
        NSLog(@"BOTTLERS_MASTER table doesn't exist");
        return nil;
    };
    
    if (![_database open]) {
        NSLog(@"Failed to open the database. :: Error: %@", _database.lastErrorMessage);
        return nil;
    }
    
    NSMutableDictionary* resultsDict   = [[NSMutableDictionary alloc] init];
    
    FMResultSet* rs = [_database executeQuery:@"SELECT * FROM BOTTLERS_MASTER WHERE IS_ACTIVE=1"];
    while ([rs next]) {
        DPSBottler* bottlerObj  = [self createBottler:rs];
        [resultsDict setObject:bottlerObj forKey:[DPSUtilities stringFromInteger:bottlerObj.bottlerId]];
    }
    
    [rs close];
    [_database close];
    
    return [resultsDict allValues];
}

- (DPSBottler*)createBottler:(FMResultSet*)rs {
    DPSBottler* bottlerObj  = [[DPSBottler alloc] init];
    bottlerObj.bottlerId    = [rs intForColumnIndex:0];
    bottlerObj.bcBottlerId  = [rs stringForColumnIndex:1];
    
    bottlerObj.name         = [[rs stringForColumnIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    bottlerObj.channelId    = [[rs stringForColumnIndex:3] integerValue];
    bottlerObj.statusId     = [rs intForColumnIndex:4];
    bottlerObj.bcRegionId   = [rs intForColumnIndex:5];
    bottlerObj.address      = [rs stringForColumnIndex:6];
    bottlerObj.city         = [rs stringForColumnIndex:7];
    bottlerObj.state        = [rs stringForColumnIndex:8];
    bottlerObj.postalCode   = [rs stringForColumnIndex:9];
    bottlerObj.country      = [rs stringForColumnIndex:10];
    bottlerObj.email        = [rs stringForColumnIndex:11];
    bottlerObj.phoneNumber  = [rs stringForColumnIndex:12];
    bottlerObj.longitude    = [[rs stringForColumnIndex:13] floatValue];
    bottlerObj.latitude     = [[rs stringForColumnIndex:14] floatValue];
    bottlerObj.isActive     = [[rs stringForColumnIndex:15] boolValue];
    bottlerObj.updatedTime  = [rs dateForColumnIndex:16];
    bottlerObj.EBID         = [rs intForColumnIndex:17];
    return bottlerObj;
}

- (IBAction)constructTData:(id)sender {
    NSArray *array = [self getAllBottlers];
    NSArray *EB4IDs = [[NSSet setWithArray:[array valueForKey:@"EBID"]] allObjects];
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < [EB4IDs count]; i++) {
        NSInteger EB4ID = [EB4IDs[i] integerValue];
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"SELF.EBID = %d",EB4ID];
        NSArray *children = [array filteredArrayUsingPredicate:predicate];
        NSMutableArray *childrenArray = [NSMutableArray array];
        for (DPSBottler *bottler in children) {
              RADataObject *dataObject = [RADataObject dataObjectWithName:bottler.name children:nil bottler:bottler.bottlerId parentId:bottler.EBID NodeType:nil];
            [childrenArray addObject:dataObject];
        }
        EBHObject *ebObj = [self getEBHWithId:EB4ID nodeType:@"EBH4"];
        RADataObject *dataObject = [RADataObject dataObjectWithName:ebObj.EBName children:childrenArray bottler:0 parentId:ebObj.parentId NodeType:@"EBH4"];
        [array1 addObject:dataObject];
    }
    NSMutableArray *eb3Array = [NSMutableArray array];
    for (RADataObject *eb4Object in array1) {
        EBHObject *ebObj = [self getEBHWithId:eb4Object.parentId nodeType:@"EBH3"];
        RADataObject *dataObject = [RADataObject dataObjectWithName:ebObj.EBName children:eb4Object.children bottler:0 parentId:ebObj.parentId NodeType:@"EBH3"];
        [eb3Array addObject:dataObject];
    }
    
    NSArray *EB2IDs = [[NSSet setWithArray:[eb3Array valueForKey:@"parentId"]] allObjects];
    NSMutableArray *array3 = [NSMutableArray array];
    for (int i = 0; i < [EB2IDs count]; i++) {
        NSInteger EB2ID = [EB2IDs[i] integerValue];
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"SELF.parentId = %d",EB2ID];
        NSArray *children = [eb3Array filteredArrayUsingPredicate:predicate];
        EBHObject *ebObj = [self getEBHWithId:EB2ID nodeType:@"EBH2"];
        RADataObject *dataObject = [RADataObject dataObjectWithName:ebObj.EBName children:children bottler:0 parentId:EB2ID NodeType:@"EBH2"];
        [array3 addObject:dataObject];
    }
    
    NSMutableArray *eb2Array = [NSMutableArray array];
    for (RADataObject *eb3Object in array3) {
        EBHObject *ebObj = [self getEBHWithId:eb3Object.parentId nodeType:@"EBH2"];
        RADataObject *dataObject = [RADataObject dataObjectWithName:ebObj.EBName children:eb3Object.children bottler:0 parentId:ebObj.parentId NodeType:@"EBH2"];
        [eb2Array addObject:dataObject];
    }
 
    NSArray *EB1IDs = [[NSSet setWithArray:[eb2Array valueForKey:@"parentId"]] allObjects];
    NSMutableArray *array2 = [NSMutableArray array];
    for (int i = 0; i < [EB1IDs count]; i++) {
        NSInteger EB1ID = [EB1IDs[i] integerValue];
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"SELF.parentId = %d",EB1ID];
        NSArray *children = [eb2Array filteredArrayUsingPredicate:predicate];
        EBHObject *ebObj = [self getEBHWithId:EB1ID nodeType:@"EBH1"];
        RADataObject *dataObject = [RADataObject dataObjectWithName:ebObj.EBName children:children bottler:0 parentId:EB1ID NodeType:@"EBH1"];
        [array2 addObject:dataObject];
    }
    
    
    NSMutableArray *eb1Array = [NSMutableArray array];
    for (RADataObject *eb2Object in eb2Array) {
        EBHObject *ebObj = [self getEBHWithId:eb2Object.parentId nodeType:@"EBH1"];
        RADataObject *dataObject = [RADataObject dataObjectWithName:ebObj.EBName children:eb2Object.children bottler:0 parentId:0 NodeType:@"EBH1"];
        [eb1Array addObject:dataObject];
    }
    RADataObject *dataObject = [RADataObject dataObjectWithName:@"RegionName" children:array2 bottler:0 parentId:0 NodeType:@"Region"];
    _eb1rray = [NSMutableArray array];
    [_eb1rray addObject:dataObject];
}

-(NSMutableArray *)getTheNodeArray:(NSArray*)array node:(NSString*)Nodetype{
    NSMutableArray *desiredArray = [NSMutableArray array];
    for (RADataObject *eb3Object in array) {
        EBHObject *ebObj = [self getEBHWithId:eb3Object.parentId nodeType:Nodetype];
        RADataObject *dataObject = [RADataObject dataObjectWithName:ebObj.EBName children:@[eb3Object] bottler:0 parentId:ebObj.parentId NodeType:@"EBH2"];
        [desiredArray addObject:dataObject];
    }
    return desiredArray;
}

- (IBAction)loadData:(id)sender {

    [self loadPromotionsForRegion];
    [self loadBottlers];
    _eb1rray = nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"Tree"]) {
        ViewController *vc = [segue destinationViewController];
        if (!_eb1rray) {
            [self constructTData:nil];
        }
        vc.data = _eb1rray;
    }
    
}


-(NSString*)encodeString:(NSString*)encodeString{
    if (encodeString && ![encodeString isKindOfClass:[NSNull class]]) {
        encodeString = [encodeString stringByReplacingOccurrencesOfString:QUOTE_STRING_ORIGINAL withString:QUOTE_STRING_REPLACED];
    }else{
        encodeString = @"";
    }
    return encodeString;
}

-(NSString*)decodeString:(NSString*)decodeString{
    if (![decodeString isKindOfClass:[NSNull class]]) {
        decodeString = [decodeString stringByReplacingOccurrencesOfString:QUOTE_STRING_REPLACED  withString:QUOTE_STRING_ORIGINAL];
    }else{
        decodeString = @"";
    }
    return decodeString;
}
@end
