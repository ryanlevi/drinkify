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
    NSURL *tutorialsUrl = [NSURL URLWithString:url];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];

    NSString *tutorialsXpathQueryString = @"//div[@id='recipeContent']";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    TFHppleElement * element = [tutorialsNodes objectAtIndex:0];
    TFHppleElement * recipe = [element firstChildWithTagName:@"ul"];
//    TFHppleElement *r = [recipe children][1];
    
    NSMutableString * result = [[NSMutableString alloc] init];
    for(TFHppleElement *i in [recipe children]){
        for (TFHppleElement *e in [i children]) {
            [result appendString:@"\u00b7 "];
            [result appendString:[e content]];
            [result appendString:@"\n"];
        }
    }

    [_searchResultsHeader setText:[NSString stringWithFormat:@"The \"%@\"", _searchBar.text]];
    [_searchResults setText:result];
}
@end
