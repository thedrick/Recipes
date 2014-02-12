//
//  MRBSingleSelectionView.m
//  Recipes
//
//  Created by Tyler Hedrick on 2/12/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import "MRBSingleSelectionView.h"

static NSString * const cellIdentifier = @"selectionCell";

@interface MRBSingleSelectionViewController ()
@end

@implementation MRBSingleSelectionViewController

- (id)init
{
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.dataSource numberOfOptionsForSingleSelectionView:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  cell.textLabel.text = [self.dataSource singleSelectionView:self optionForRowAtIndexPath:indexPath];
  return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.delegate singleSelectionView:self didSelectIndex:indexPath];
}

#pragma mark -
#pragma mark Accessors

- (void)setDelegate:(id<MRBSingleSelectionViewDelegate>)delegate
{
  if ([_delegate isEqual:delegate]) {
    return;
  }
  _delegate = nil;
  _delegate = delegate;
  [self.tableView reloadData];
}

- (void)setDataSource:(id<MRBSingleSelectionViewDataSource>)dataSource
{
  if ([_dataSource isEqual:dataSource]) {
    return;
  }
  _dataSource = nil;
  _dataSource = dataSource;
  NSInteger numberOfRows = [_dataSource numberOfOptionsForSingleSelectionView:self];
  self.tableView.frame = CGRectMake(0, 0, 240, 40.0 * numberOfRows);
  self.view.frame = self.tableView.frame;
  [self.tableView reloadData];
}

@end