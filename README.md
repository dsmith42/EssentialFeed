# Essential Feed - Image Feed Feature

[![CI](https://github.com/dsmith42/EssentialFeed/actions/workflows/CI.yml/badge.svg)](https://github.com/dsmith42/EssentialFeed/actions/workflows/CI.yml)

This is my implementation of the EssentialFeed app part of the Essential Developer Lead Essentials course. [Essential Developer](https://www.essentialdeveloper.com/)

An in depth course covering architecture, design patterns and building scalable and thoroughly tested iOS Applications using the TDD methodology.

## BDD Specs

### Story: Customer requests to see their image feed

### Narrative #1
```
As an online customer
I want the app to automatically loaqd my latest image feed
So I can always enjoy the newest images of my friends
```
### Scenarios (Acceptance criteria)
```
Given the customer has connectivity
 When the customer requests to see their feed
 Then the app should display the latest feed from remote
  And replace the cache with the new feed
```
### Narative #2
```
As an offline customer
I watnt the app to show the latest saved version of my image feed
So I can always enjoy images of my friends
```
### Scenarios (Acceptance criteria)
```
Given the customer doesn't have connectivity
  And there's a cached version of the feed
  And the cache is less than seven days old
 When the customer requests to see the feed
 Then the app should display the latest feed saved

Given the customer doesn't have connectivity
  And there's a cached version of the feed
  And the cache is more than seven days old
 When the customer requests to see the feed
 Then the app should display an error message

Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the feed
 Then the app should display an error message
```

## Use Cases

### Load Feed From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Feed" command with above data.
2. System downloads data from the URL
3. System validates downloaded data.
4. System creates image feed from valid data.
5. System delivers image feed.

#### Invalid data - error course (sad path):
1. System delivers invalid data error.

#### No connectivity - error course (sad path):
1. System delivers no connectivity  error.

---
### Load Feed Image Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Feed From Cache Use Case

#### Data:
- Max age (7 days)

#### Primary course:
1. Execute "Load Image Feed" command with above data.
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.
4. System creates image feed from cached data.
5. System delives image feed.

#### Retrieval Error course (sad path):
1. System delivers error.

#### Expired cache course (sad path):
1. System delivers no image feed.

#### Empty cache course (sad path):
1. System delivers no image feed.

---

### Load Feed Image Data From Cache Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System retrieves data from the cache.
3. System delivers cached image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers not found error.

---

### Validate Feed From Cache Use Case

#### Data:
- Max age (7 days)

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.

#### Retrieval Error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path):
1. System deletes cache.

---

### Cache Feed Use Case

#### Data:
- Image Feed

#### Primary course (happy path):
1. Execute "Save Image Feed" command with above data.
2. System deletes old cache data.
3. System encodes image feed.
4. System timestamps the new cache.
5. System saves the new data to cache.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

## Architecture

## Model Specs

### Feed Image

| Property      | Type                |
|---------------|---------------------|
| `id`          | `UUID`              |
| `description` | `String` (optional) |
| `location`    | `String` (optional) |
| `url`         | `URL`               |

## UK goals for the Feed UI experiences

[ ] Load feed automatically when view is presented
[ ] Allow customer to manually reload feed (pull to refresh)
[ ] Show a loading indicator while loading feed
[ ] Render all loaded feed items (location, image, description)
[ ] Image loading experience
  [ ] Load when image view is visible (on the screen)
  [ ] Cancel when image view is out of screen
  [ ] Show a loading indicator while loading image (shimmer)
  [ ] Optoin ot retry on image download error
  [ ] Preload when image view is near visible

### Payload contract

```
GET *url* (TBD)

200 RESPONSE

{
	"items": [
		{
			"id": "73A7F70C-75DA-4C2E-B5A3-EED40DC53AA6",
			"description": "Description 1",
			"location": "Location 1",
			"image": "https://url-1.com",
		},
		{
			"id": "BA298A85-6275-48D3-8315-9C8F7C1CD109",
			"location": "Location 2",
			"image": "https://url-2.com",
		},
		{
			"id": "5A0D45B3-8E26-4385-8C5D-213E160A5E3C",
			"description": "Description 3",
			"image": "https://url-3.com",
		},
		{
			"id": "FF0ECFE2-2879-403F-8DBE-A83B4010B340",
			"image": "https://url-4.com",
		},
		{
			"id": "DC97EF5E-2CC9-4905-A8AD-3C351C311001",
			"description": "Description 5",
			"location": "Location 5",
			"image": "https://url-5.com",
		},
		{
			"id": "557D87F1-25D3-4D77-82E9-364B2ED9CB30",
			"description": "Description 6",
			"location": "Location 6",
			"image": "https://url-6.com",
		},
		{
			"id": "A83284EF-C2DF-415D-AB73-2A9B8B04950B",
			"description": "Description 7",
			"location": "Location 7",
			"image": "https://url-7.com",
		},
		{
			"id": "F79BD7F8-063F-46E2-8147-A67635C3BB01",
			"description": "Description 8",
			"location": "Location 8",
			"image": "https://url-8.com",
		}
	]
}
```
