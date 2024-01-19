# CheckPoint

A monitoring service to track the status of services that you depend on!

The application will run checks repeatedly (default every 3 minutes) and
trigger and alert if the checks fails 3 times in a row.

The check_point database consists of these tables:

checks - each row contains the check service to be monitored, the target (URL) 
that is running that service, and a link to the contact that should be alerted
if the service fails.  Currently the only service that can be monitored is
HTTP(S), and will succeed or fail based on the URL giving a reply when sent 
a GET request.  Other services, GREEN and RED, are present for testing and 
will always succeed or fail.  Future services could include ICMP ping, port
checking, and even searching an HTTP response for a given regex.

contacts - each row gives a short name to the contact, a field for a noame or
description, and the details to be used to send an alert.  Currently the only
alerts supported are by triggering a GraphQL subscription, but this can be 
extended to using chatbots, text paging, email, etc.

The monitoring service consists of Watchers, Alarms, and Alerts.

A Watcher is a dedicated process that will run a given check and possibly
set an alarm if the check fails.  The Watcher will then sleep for a specified
time and repeat.

An Alarm is set when a check fails the first time.  It will run the same check
but at a faster pace.  If the alarm fails three times in a row, it will send
and Alert to the contact for the check.  If the alarm succeeds even once, it
stop without sending an Alert.

Currently the only Alert that is supported is to trigger a Graphql endpoint.  It
is only run once, but is implemented as a Task so that any processing can be 
offloaded from the Alarm, and to make it modular to drop in multiple types
of Alerts.

Roadmap:

Group contacts into different accounts and provide account management where 
an account can set a default contact to recieve alerts, etc.  
This would also require authenication and authorization.

An HTML dashboard for account management and so that contacts can view 
alerts and history.

## Take-aways

This project demonstrates the use of GenServers, Tasks, and GraphQL along with Ecto

You Ain't Going to Need IT!  -- While coding this I realized that all the bells
and whistles for my original idea were not needed to develop a minimum
viable product (or proof of concept).  I ended up simplifying and simplifying
multiple times so I could show the simple idea behind the application.

