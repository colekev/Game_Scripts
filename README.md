# Game Scripts

This analysis builds off the work from Chase Stuart at [Football Perspective](http://www.footballperspective.com/) for determining a better calculation than traditional score differential. 

Chase explains it as:
    "The term Game Script is just shorthand for the average points differential for a team over every second of each game."
    
[My code](https://github.com/colekev/Game_Scripts/blob/master/Game%20Script%20Calc.R) uses [Armchair Analysis](http://www.armchairanalysis.com/) data to calculate the score differential for each team for every second of every game. That is then compared to the pass ratio to see if teams are more pass- or run-heavy than you'd expected based on the treadline for the entire league. 

In this example, I [plotted the New England Patriots' game scripts](https://github.com/colekev/Game_Scripts/blob/master/gs_2015_NE.png) against the backdrop of the entire 2015 season. You can see that the Patriots are extremely pass-heavy, with only two games all season long where they ran more often than expect based on the league trendline.

I used this analysis to show that Lamar Miller's lack of rushing attempts with Joe Philbin at the helm was [more about negative game script](http://rotoviz.com/2015/10/dan-campbell-saved-lamar-millers-season/) than ignoring the run game.
