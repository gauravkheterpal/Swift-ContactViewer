//
//  DataClass.h
//  SFTest
//
//  Created by Gaurav Kheterpal on 02/02/15.
//  Copyright (c) 2015 Gaurav Kheterpal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject
@property (nonatomic,weak) id delegate;
-(void)fetchContacts;
-(void)fetchContactDetail:(NSString*)contactId;
@end
@protocol FetchContactDelegate <NSObject>

- (void)fetchContactSuccess:(NSArray*)records;
- (void)fetchContactFailed:(NSError*)error;
@end