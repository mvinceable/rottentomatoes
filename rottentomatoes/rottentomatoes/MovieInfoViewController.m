//
//  MovieInfoViewController.m
//  rottentomatoes
//
//  Created by Vince Magistrado on 9/16/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import "MovieInfoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bigPosterView;
@property (weak, nonatomic) IBOutlet UILabel *bigSynopsisLabel;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *posterUrl;
@property (strong, nonatomic) NSString *synopsis;
@end

@implementation MovieInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTitle:(NSString *)title imgUrl:(NSString *)imgUrl synopsis:(NSString *)synopsis
{
    self = [super init];
    self.title = title;
    self.posterUrl = imgUrl;
    self.synopsis = synopsis;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.title;
    [self.bigPosterView setImageWithURL:[NSURL URLWithString:self.posterUrl]];
    self.bigSynopsisLabel.text = self.synopsis;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
