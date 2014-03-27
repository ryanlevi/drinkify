//
//  RLViewController.h
//  Drinkify
//
//  Created by Ryan Levi on 3/26/14.
//  Copyright (c) 2014 Ryan Levi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
- (IBAction)searchButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *searchResults;
@property (weak, nonatomic) IBOutlet UITextView *searchResultsHeader;

@end
