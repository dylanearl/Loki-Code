//
//  DiscoveryController.m
//  Test_Discovery
//
//  Created by Dylan Earl on 5/05/2015.
//  Copyright (c) 2015 Dylan Earl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiscoveryController.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define NUM_SEARCHES 20

@implementation DiscoveryController
- (NSArray *) discover {
   int i = 0;
   char *request = "M-SEARCH * HTTP/1.1\r\nHOST:239.255.255.250:1900\r\nMAN:\"ssdp:discover\"\r\nST:ssdp:all\r\nMX:3\r\n\r\n";
   long recvlen;
   char stringbuf[NUM_SEARCHES+1][5000];
   
   NSString * devices = @"devinf:\n";
   xml_info = [[NSMutableArray alloc] initWithCapacity:NUM_SEARCHES+1];
   xml_unique = [[NSMutableArray alloc] initWithCapacity:NUM_SEARCHES+1];
   char uuids[NUM_SEARCHES+1][200];
   char locations[NUM_SEARCHES+1][200];
   
   // Open a socket
   int sd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
   if (sd<=0) {
      //NSLog(@"Error: Could not open socket");
      return 0;
   }
   
   // Set socket options
   // Enable broadcast
   int broadcastEnable=1;
   int ret=setsockopt(sd, SOL_SOCKET, SO_BROADCAST, &broadcastEnable, sizeof(broadcastEnable));
   if (ret) {
      //NSLog(@"Error: Could not open set socket to broadcast mode");
      close(sd);
      return 0;
   }
   
   //set recvfrom timeout
   struct timeval tv;
   tv.tv_sec = 0.05; //0.05 second timeout
   int to = setsockopt(sd, SOL_SOCKET, SO_RCVTIMEO, (struct timeval *)&tv, sizeof(tv));
   if (to) {
      //NSLog(@"Error: Could not set socket receivefrom timeout");
      close(sd);
      return 0;
   }
   
   // Since we don't call bind() here, the system decides on the port for us
   
   // Configure the port and ip we want to send to
   struct sockaddr_in broadcastAddr;
   memset(&broadcastAddr, 0, sizeof broadcastAddr);
   broadcastAddr.sin_family = AF_INET;                               //set address family - IPv4
   inet_pton(AF_INET, "239.255.255.250", &broadcastAddr.sin_addr);   // Set the broadcast IP address
   broadcastAddr.sin_port = htons(1900);                             // Set port to 1900 (standard)
   
   // Send the broadcast request
   //ST = search target, MX = max waiting time for response
   ret = sendto(sd, request, strlen(request), 0, (struct sockaddr*)&broadcastAddr, sizeof(broadcastAddr));
   if (ret < 0) {
      //NSLog(@"Error: Could not open send broadcast");
      close(sd);
      return 0;
   }
   
   //receive message
   char recstring[5000];
   int j,k = 0;
   //recvlen = recvfrom(sd, &recstring, sizeof(stringbuf), 0, 0,0);
   for (j = 0; j <= NUM_SEARCHES; j++) {
      //NSLog(@"Receiving:: %d", j);
      recvlen = recvfrom(sd, &recstring, sizeof(stringbuf), 0, 0,0);
      if (recvlen == 0) {
         //NSLog(@"Miss");
      } else if (strcmp(recstring, stringbuf[k]) == 0) {
         //printf ("same!");
      } else {
         strcpy(stringbuf[k], recstring);
         //printf("Received: %s\n", stringbuf[k]);
         k++;
      }
   }
   close(sd);
   
   for(i = 0; i < k; i++) {
      //convert to lower
      for (j = 0; j < strlen(stringbuf[i]); j++) {
         stringbuf[i][j] = tolower(stringbuf[i][j]);
      }
      
      //search for UUID info
      for (j = 0; j < strlen(stringbuf[i]) - 5; j++) {
         if ((stringbuf[i][j] == 'u') && (stringbuf[i][j+1] == 'u') && (stringbuf[i][j+2] == 'i') && (stringbuf[i][j+3] == 'd') && (stringbuf[i][j+4] == ':')){
     //       NSLog(@"%i founddd", i);
            j = j+5;
            int found = j;
            while (j < strlen(stringbuf[i]) && stringbuf[i][j] != '\r' && stringbuf[i][j] != '\0') {
               j++;
            }
            memcpy(uuids[i], &stringbuf[i][found], j-found);
            uuids[i][j-found] = '\n';
            uuids[i][j-found+1] = '\0';
            devices = [devices stringByAppendingString:[NSString stringWithUTF8String:uuids[i]]];
            //printf("%s\n", uuids[i]);
            break;
         }
      }
      
      //search for LOCATION info
      for (j = 0; j < strlen(stringbuf[i]) - 10; j++) {
         //printf("%c",stringbuf[i][j]);
         // NSLog(@"%s-", &stringbuf[1]);
         if ((stringbuf[i][j] == 'l') && (stringbuf[i][j+1] == 'o') && (stringbuf[i][j+2] == 'c') && (stringbuf[i][j+3] == 'a') && (stringbuf[i][j+4] == 't') && (stringbuf[i][j+5] == 'i') && (stringbuf[i][j+6] == 'o') && (stringbuf[i][j+7] == 'n') && (stringbuf[i][j+8] == ':')){
      //      NSLog(@"%i found", i);
            j = j+9;
            //remove leading space
            if (stringbuf[i][j] == ' '){
               j = j+1;
            }
            int found = j;
            while (j < strlen(stringbuf[i]) && stringbuf[i][j] != '\r' && stringbuf[i][j] != '\0') {
               j++;
            }
            memcpy(locations[i], &stringbuf[i][found], j-found);

            locations[i][j-found] = '\0';
            [xml_info addObject: [NSString stringWithFormat: @"%s", locations[i]]];
            devices = [devices stringByAppendingString:[NSString stringWithUTF8String:locations[i]]];
            break;
         }
      }
   }
  
   xml_unique = [xml_info valueForKeyPath:@"@distinctUnionOfObjects.self"];
   
   //NSLog(@"Locations:\n %@", xml_unique);
   
   //NSLog(@"Here are the devices:\n%@", devices);
   return xml_unique;
}

@end