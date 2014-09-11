//
//  ViewController.m
//  #5_Post_Request
//
//  Created by Aditya Narayan on 9/11/14.
//  Copyright (c) 2014 NM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Create the request for asynchronous download
    NSURL *postURL = [NSURL URLWithString:@"http://protected-wildwood-8664.herokuapp.com/users"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL];
    //specify that it is a GET request
    request.HTTPMethod = @"POST";
    
    self.userID = @"burea1124";
    self.latitude = @11;
    self.longitude = @24;
    self.radius = @100;
    
    NSDictionary *userDetails = @{@"user":@{
                                      @"username": self.userID,
                                      @"latitude": self.latitude,
                                      @"longitude": self.longitude,
                                      @"radius": self.radius},
                                      @"commit":@"Create User",
                                      @"action":@"update",
                                      @"controller":@"users"
                                  };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDetails options:0 error:&error]; //note the ampersand for the error
    //at this point, I have translated a NSDictionary object to a NSData object using NSJSONSerialization method. Now, the Dictionary object is in "hex bytes" data format ready to be converted into a JSON string
    
    NSString *myJSONString; //create an empty string
    myJSONString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; //convert the NSData object from before into a valid JSON STRING
    NSLog(@"%@", myJSONString);
    
    //Now convert back the JSON String into a NSData object that can be appended to our NSURLRequest object
    
    NSData *myJSONrequest = [myJSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    //you need to define the HeaderField values like below before you can submit the request, otherwise it won't work
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [myJSONrequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: myJSONrequest];

    //create url connection and fire the request you made above
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest: request delegate: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLConnection Delegate Methods

- (void) connection:(NSURLConnection* )connection didReceiveResponse:(NSURLResponse *)response {
    //this handler, gets hit ONCE
    //response has been received, we initialize the instance var we created in h file
    //then we append data to it in the didReceiveData method
    //    responseData = [[NSMutableData alloc] init];
}

- (void)connection: (NSURLConnection *)connection didReceiveData:(NSData *) dataYouGot {
    //this handler, gets hit SEVERAL TIMES
    //Append new data to the instance variable everytime new data comes in
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    //Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //this handler, gets hit ONCE
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now or do whatever you want
    
    NSLog(@"connection finished");
    
    //    //if you just log out responseData here,
    //    NSString *strData = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@", strData);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}


@end
