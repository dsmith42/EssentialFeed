# Essential Feed

[![CI](https://github.com/dsmith42/EssentialFeed/actions/workflows/CI.yml/badge.svg)](https://github.com/dsmith42/EssentialFeed/actions/workflows/CI.yml)

A project to help me learn and practice good software design and principles.

### Story: Customer requests to see their image feed

#### Narrative #1
```
As an online customer
I want the app to automatically loaqd my latest image feed
So I can always enjoy the newest images of my friends
```
#### Scenarios (Acceptance criteria)
```
Given the customer has connectivity
 When the customer requests to see their feed
 Then the app should display the latest feed from remote
  And replace the cache with the new feed
```
#### Narative #2
```
As an offline customer
I watnt the app to show the latest saved version of my image feed
So I can always enjoy images of my friends
```
##### Scenarios (Acceptance criteria)
```
Given the customer doesn't have connectivity
  And there's a cached version of the feed
 When the customer requests to see the feed
 Then the app should display the latest feed saved

Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the feed
 Then the app should display an error message
```
