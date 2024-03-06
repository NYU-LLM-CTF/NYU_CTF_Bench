

# Design

1. user.py will be served to users
2. app.py will not be served to users and will serve as 
3. a intermediary that pulls a thread and automatically buys 
4. call orders. 


# Restoration logic

network queue:

invalid sell, invalid sell, post call, invalid sell, invalid sell

one of the pre-post sell will throttle, hence throttling all post-post sell,
the post will go through, deducting the portfolio, but the next throttling
invalid sell will restore the stock portfolio to the original

causing a delta of 1 extra stock call.




