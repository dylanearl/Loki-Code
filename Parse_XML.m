//
//  Parse_XML.m
//  Test_Discovery
//
//  Created by Dylan Earl on 5/05/2015.
//  Copyright (c) 2015 Dylan Earl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse_XML.h"

@implementation Parse_XML
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
   NSLog(@"File found and parsing started");
}

- (void)parseXMLFileAtURL:(NSString *)URL
{
   
   NSString *agentString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                   [NSURL URLWithString:URL]];
   [request setValue:agentString forHTTPHeaderField:@"User-Agent"];
   NSData * xmlFile = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
   
   
   articles = [[NSMutableArray alloc] init];
   errorParsing=NO;
   
   rssParser = [[NSXMLParser alloc] initWithData:xmlFile];
   [rssParser setDelegate:self];
   
   // You may need to turn some of these on depending on the type of XML file you are parsing
   [rssParser setShouldProcessNamespaces:NO];
   [rssParser setShouldReportNamespacePrefixes:NO];
   [rssParser setShouldResolveExternalEntities:NO];
   
   [rssParser parse];
   
   
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
   
   NSString *errorString = [NSString stringWithFormat:@"Error code %li", (long)[parseError code]];
   NSLog(@"Error parsing XML: %@", errorString);
   
   
   errorParsing=YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
   currentElement = [elementName copy];
   //NSLog(@"%@", currentElement);
   ElementValue = [[NSMutableString alloc] init];
   if ([elementName isEqualToString:@"manufacturer"]) {
      item = [[NSMutableDictionary alloc] init];
      //NSLog(@"found: %@", articles);
   }
   
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
   [ElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
   if ([elementName isEqualToString:@"service"]) {
      NSLog(@"Ended element");
      [articles addObject:[item copy]];
   } else {
      [item setObject:ElementValue forKey:elementName];
   }
   
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
   
   if (errorParsing == NO)
   {
      NSLog(@"XML processing done!");
      NSLog(@"Manufacturer: %@", item[@"manufacturer"]);
      NSLog(@"Model Name: %@", item[@"modelName"]);
      NSLog(@"Serial Number: %@", item[@"serialNumber"]);
      NSLog(@"Mac Address: %@", item[@"macAddress"]);
      
      //NSLog(@"FOUND ARTICLES%@", articles);
   } else {
      NSLog(@"Error occurred during XML processing");
   }
}
/*
- (NSMutableArray *)returnData {
   return articles;
}*/
@end