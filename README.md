# CheckPoint

A monitoring service to track the status of services that you depend on!

The application will run tests repeatedly (default every 3 minutes) and
trigger and alert if the test fails 3 times in a row.

Currently this is developed with a GraphQL interface and with alerts
handled through triggering subscriptions to GraphQL endpoints.

Eventually I want to add multiple types of checks that this can do
and also multiple types of notifications (Text, email, phone calls...)

I also would like to be able to group contact into different accounts
and provide account management where an account can set a default contact
to recieve alerts, etc.  This would also require authenication and 
authorization.

And I will eventually add an HTML dashboard for this management and
so that contacts can view alerts and history.

## Take-aways

This project demonstrates the use of GenServers, Tasks, and GraphQL along with Ecto

You Ain't Going to Need IT!  -- While coding this I realized that all the bells
and whistles for my original idea were not needed to develop a minimum
viable product (or proof of concept).  I ended up simplifying and simplifying
multiple times so I could show the simple idea behind the application.

