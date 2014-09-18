//
//  MoviesViewController.m
//  rottentomatoes
//
//  Created by Vince Magistrado on 9/11/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "MovieInfoViewController.h"

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;
@property (nonatomic, strong) UIRefreshControl *refreshMoviesControl;
@property (nonatomic) BOOL firstTimeLoading;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.firstTimeLoading = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Configure the title
    self.navigationItem.title = @"Rotten Tomatoes";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 112;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    self.refreshMoviesControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshMoviesControl];
    [self.refreshMoviesControl addTarget:self action:@selector(refreshMovies) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMovieTap:)];
    [self.tableView addGestureRecognizer:tap];
    
    [self refreshMovies];
    
    // customize back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Movies" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    NSLog(@"Finished with viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    
    NSLog(@"index path: %d", indexPath.row);
    
    return cell;
}

- (void)refreshMovies
{
    // clear errors
    [self hideNetworkError];
    
    // add a loading view only for first time loading
    if (self.firstTimeLoading) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = @"Loading";
    }
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // hide the loading view
        if (self.firstTimeLoading) {
            [self.hud hide:YES];
            self.firstTimeLoading = NO;
        } else {
            [self.refreshMoviesControl endRefreshing];
        }
        
        if (!connectionError) {
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = object[@"movies"];
            
            [self.tableView reloadData];
            
            //            NSLog(@"movies: %@", self.movies);
        } else {
            // display an error alert
            [self showNetworkError];
        }
    }];
}

- (void)hideNetworkError
{
    [self.networkErrorLabel setHidden:YES];
}

- (void)showNetworkError
{
    [self.networkErrorLabel setHidden:NO];
}

-(void) onMovieTap:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    NSLog(@"movie %d tapped", indexPath.row);
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
        NSDictionary *movie = self.movies[indexPath.row];
        NSString *title = movie[@"title"];
        NSString *synopsis = movie[@"synopsis"];
        // replace thumbnail url with original
        NSString *posterUrl = [[movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_org.jpg"];
        MovieInfoViewController *vc = [[MovieInfoViewController alloc] initWithTitle:title imgUrl:posterUrl synopsis:synopsis];
        [self.navigationController pushViewController:vc animated:YES];
    } else { // anywhere else, do what is needed for your case
        //[self.navigationController popViewControllerAnimated:YES];
    }
}
@end
