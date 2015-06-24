# Ranked Pair Voting

Playing around with [ranked pairs voting](https://en.wikipedia.org/wiki/Ranked_pairs).

### Creating a Contest

    contest = Contest.new

### Voting

    winner = "Winnie Walters"
    loser = "Louise R. Lemon"
    contest.vote(winner, loser)

### Outcomes by Contestant

    contest.outcomes_by_contestant

    => {"Louise R. Lemon"=>#<OpenStruct wins=0, ties=0, losses=1>, "Winnie Walters"=>#<OpenStruct wins=1, ties=0, losses=0>} 

### Leaderboard

    contest.leaderboard

    => ["Winnie Walters", "Louise R. Lemon"]

### A more complete example

    require './ranked_pairs.rb'
    choices = [*?a..?z]
    contest = Contest.new

    10000.times do
      contest.vote(choices.sample, choices.sample)
    end

    => ["g", "w", "i", "u", "q", "b", "j", "z", "k", "d", "m", "h", "s", "r", "t", "f", "c", "y", "n", "v", "e", "o", "x", "p", "l", "a"] 
