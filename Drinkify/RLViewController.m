//
//  RLViewController.m
//  Drinkify
//
//  Created by Ryan Levi on 3/26/14.
//  Copyright (c) 2014 Ryan Levi. All rights reserved.
//

#import "RLViewController.h"
#import "TFHpple.h"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButton:(id)sender {
    NSString * url = [NSString stringWithFormat:@"http://drinkify.org/%@", [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *drinkifyUrl = [NSURL URLWithString:url];
    NSData *drinkifyHtmlData = [NSData dataWithContentsOfURL:drinkifyUrl];
    [_searchResultsHeader setFont:[UIFont fontWithName:@"Futura" size:20.0]];
    
    if(drinkifyHtmlData == nil){
        [_searchResultsHeader setText:[NSString stringWithFormat:@"%@ not found", _searchBar.text]];
        [_searchResults setText:@""];
        return;
    }
    
    [_searchResults setFont:[UIFont fontWithName:@"Futura" size:16.0]];
    TFHpple *drinkifyParser = [TFHpple hppleWithHTMLData:drinkifyHtmlData];

    NSString *drinkifyXpathQueryString = @"//div[@id='recipeContent']";
    NSArray *drinkifyNodes = [drinkifyParser searchWithXPathQuery:drinkifyXpathQueryString];
    TFHppleElement * element = [drinkifyNodes objectAtIndex:0];
    NSString * drinkName = [[element firstChildWithTagName:@"h2"] text];
    TFHppleElement * recipe = [element firstChildWithTagName:@"ul"];
    
    NSMutableString * result = [[NSMutableString alloc] init];
    for(TFHppleElement *i in [recipe children]){
        for (TFHppleElement *e in [i children]) {
            [result appendString:@"\u00b7 "];
            [result appendString:[e content]];
            [result appendString:@"\n"];
        }
    }

    [_searchResultsHeader setText:drinkName];
    [_searchResults setText:result];
}
@end
