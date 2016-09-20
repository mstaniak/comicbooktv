---
title: "Data download"
output: html_output
---

### About the data

All shows based on DC or Marvel comicbooks that aired on TV or Netflix since 2012 are presented.  
IMDb ratings were chosen because of popularity (see [www.ale.com/siteinfo/imdb.com](alexa rank))
and easy access to user-submitted ratings for each episode.  
Nielsen ratings are usually reported in the form ratings/share.
Ratings represent percentage of all television household that watched the episode of the show.
Share wasn't used in this app. 
These are basic numbers that describe live viewership.
They don't include DVR, Hulu, etc.
So called +3 or +7 ratings are interesting, but not as available.

The data was scrapped from three sources:

* [IMDb](https://www.imdb.com) (user ratings, air dates, titles, channels)
* [wikipedia](https://www.wikipedia.org) (Nielsen ratings and number of viewers for shows other than Arrow)
* [tvseriesfinale](http://www.tvseriesfinale.com) (ratings for Arrow).

### Download

Data used in this App can be downloaded by clicking on this link:

[Download](comicbooktv.xls).

It contains more information than can be seen in the App.
Explanation is given below.

| Column name       | Content |
| ----------------- | ------- |
| numOfVotes        | Number of people who voted on a given episode on IMDb |
| viewers           | Number of live viewers in millions as given by Nielsen |
| critics           | Percentage of "fresh" ratings from critics on RottenTomatoes |
| audience          | Percentage o "fresh" ratings from audience on RottenTomatoes |
| criticsAverage    | Average score from critics on RottenTomatoes (on scale 1-10) |
| audienceAverage   | Average score from audience on RottenTomatoes (on scale 1-5)|
| rating            | IMDb or Nielsen rating (as given in typeRating column) for an episode |

---

All the data is available online and can be downloaded from said websites.

