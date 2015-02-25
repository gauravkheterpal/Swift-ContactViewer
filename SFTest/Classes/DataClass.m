//
//  DataClass.m
//  SFTest
//
//  Created by Gaurav Kheterpal on 02/02/15.
//  Copyright (c) 2015 Gaurav Kheterpal. All rights reserved.
//

#import "DataClass.h"
#import "SFRestAPI+Blocks.h"
#import "SFRestRequest.h"
@implementation DataClass

-(void)fetchContacts{
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name,Id from Contact Order by Name"];
    [[SFRestAPI sharedInstance] sendRESTRequest:request failBlock:^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate fetchContactFailed:error];
        });
        
    } completeBlock:^(NSDictionary *recordDict) {
        
        //NSLog(@"fetchContacts :%@",recordDict);
        NSArray *records = [recordDict objectForKey:@"records"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate fetchContactSuccess:records];
        });
        
    }];
}
-(void)fetchContactDetail:(NSString*)contactId {
    NSString *queryString = [NSString stringWithFormat:@"SELECT  FirstName,LastName,Account.Name,Email,Phone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Title from Contact where Id = '%@'",contactId];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:queryString];
    [[SFRestAPI sharedInstance] sendRESTRequest:request failBlock:^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate fetchContactFailed:error];
        });
        
    } completeBlock:^(NSDictionary *recordDict) {
        NSLog(@"fetchContactDetail :%@",recordDict);
        NSArray *records = [recordDict objectForKey:@"records"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate fetchContactSuccess:records];
        });
    }];
    
}
@end
