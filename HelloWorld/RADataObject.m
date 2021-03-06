
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RADataObject.h"

@implementation RADataObject

- (id)initWithName:(NSString *)name children:(NSArray *)children withBottler:(NSInteger)bottlerId parentId:(NSInteger)parentId NodeType:(NSString*)nodeType
{
  self = [super init];
  if (self) {
    self.children = [NSArray arrayWithArray:children];
      if (bottlerId) {
          self.isLeafNode = true;
          self.bottlerId  = bottlerId;
      }
    self.parentId = parentId;
    self.nodeType = nodeType;
    self.name     = name;
  }
  return self;
}


+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children bottler:(NSInteger)bottler parentId:(NSInteger)parentId NodeType:(NSString*)nodeType
{
    return [[self alloc] initWithName:name children:children withBottler:bottler parentId:parentId NodeType:nodeType];
}

- (void)addChild:(id)child
{
  NSMutableArray *children = [self.children mutableCopy];
  [children insertObject:child atIndex:0];
  self.children = [children copy];
}

- (void)removeChild:(id)child
{
  NSMutableArray *children = [self.children mutableCopy];
  [children removeObject:child];
  self.children = [children copy];
}

-(void)selectAllChilds:(BOOL)select{
    if (self.children) {
        self.isSelected = select;
        if (self.children.count) {
            for (int i = 0; i < self.children.count; i++) {
               RADataObject *dataObject = self.children[i];
                dataObject.isSelected = select;
                [dataObject selectAllChilds:select];
            }
            
        }
    }
}





@end
