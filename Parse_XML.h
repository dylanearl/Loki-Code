//
//  Parse_XML.h
//  Test_Discovery
//
//  Created by Dylan Earl on 5/05/2015.
//  Copyright (c) 2015 Dylan Earl. All rights reserved.
//

//#ifndef Test_Discovery_Parse_XML_h
//#define Test_Discovery_Parse_XML_h
//#endif
#import <Foundation/Foundation.h>

//@interface Parse_XML: NSObject {
@interface Parse_XML: NSObject <NSXMLParserDelegate> {

NSXMLParser *rssParser;
NSMutableArray *articles;
NSMutableDictionary *item;
NSString *currentElement;
NSMutableString *ElementValue;
BOOL errorParsing;
}

@property (strong, nonatomic) NSString *url;

- (void)parserDidStartDocument:(NSXMLParser *)parser;

- (void)parseXMLFileAtURL:(NSString *)URL;

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;

- (void)parserDidEndDocument:(NSXMLParser *)parser;

//- (NSMutableArray *)returnData;

@end