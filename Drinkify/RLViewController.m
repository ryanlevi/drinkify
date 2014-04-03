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
    if([_searchBar.text isEqualToString:@""]) return; // if button is pressed without typing in something, do nothing
    NSString * url = [NSString stringWithFormat:@"http://drinkify.org/%@", [_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *drinkifyUrl = [NSURL URLWithString:url];
    NSData *drinkifyHtmlData = [NSData dataWithContentsOfURL:drinkifyUrl];
    
    // if no results found, return error message
    if(drinkifyHtmlData == nil){
        [_searchResultsHeader setText:[NSString stringWithFormat:@"%@ not found", _searchBar.text]];
        [_searchResults setText:@""];
        [_searchResultsHeader setFont:[UIFont fontWithName:@"Futura-Medium" size:20.0]];
        return;
    }
    
    TFHpple *drinkifyParser = [TFHpple hppleWithHTMLData:drinkifyHtmlData]; // parses URL of search

    NSString *drinkifyXpathQueryString = @"//div[@id='recipeContent']";
    NSArray *drinkifyNodes = [drinkifyParser searchWithXPathQuery:drinkifyXpathQueryString];
    TFHppleElement * element = [drinkifyNodes objectAtIndex:0];
    NSString * drinkName = [[element firstChildWithTagName:@"h2"] text]; // this is the drink name
    TFHppleElement * recipe = [element firstChildWithTagName:@"ul"]; // this is the drink recipe
    NSString *drinkInstructions = [[[element firstChildWithTagName:@"p"] text] stringByReplacingOccurrencesOfString:@"\n" withString:@""]; // this is how to serve the drink
    
    NSMutableString * result = [[NSMutableString alloc] init];
    for(TFHppleElement *i in [recipe children]){
        for (TFHppleElement *e in [i children]) {
            // prints each item in the recipe with bullets
            [result appendString:@"\u00b7 "];
            [result appendString:[e content]];
            [result appendString:@"\n"];
        }
    }
    
    [result appendString:drinkInstructions]; // adds the serving instructions to the end of the recipe

    [_searchResultsHeader setText:[drinkName uppercaseString]];
    [_searchResultsHeader setFont:[UIFont fontWithName:@"Futura-Medium" size:17.0]];
    [_searchResults setText:result];
    [_searchResults setFont:[UIFont fontWithName:@"Futura-Medium" size:14.0]];
    
    [_searchBar resignFirstResponder]; // hides keyboard after search complete
}
@end
