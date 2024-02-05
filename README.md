# CheckPoint

A monitoring service to track the status of services that you depend on!

The application will run checks repeatedly (default every 3 minutes) and
trigger an alert if the checks fails 3 times in a row.

The check_point database consists of these tables:

checks - each row contains a service probe to be monitored, the target (URL) 
that is running that service, and a link to the contact that should be alerted
if the probe fails.  Currently the only probe that can be monitored is
HTTP(S), and will succeed or fail based on the URL responding without error when 
sent a GET request.  Other probes, GREEN and RED, are present for testing and 
will always succeed or fail.  Future probes could include ICMP ping, port
checking, and even searching an HTTP response for a given regex.

contacts - each row gives a short name to the contact, a field for a description
(or person's name), and the details to be used to send an alert (currently not used).

The monitoring service consists of Watchers, Alarms, and Notify.

A Watcher is a dedicated process that will run a given check and possibly
set an alarm if the probe fails.  The Watcher will then sleep for a specified
time and repeat.

An Alarm is set when a probe fails the first time.  It will run the same probe
but at a faster pace.  If the alarm fails three times in a row, it will send
a Notify to the contact for the check.  If the alarm succeeds even once, it
stops without sending an Notify.

Currently the only Notify that is supported is to trigger a Graphql endpoint.  It
is only run once, but is implemented as a Task so that any processing can be 
offloaded from the Alarm, and to make it modular to drop in multiple types
of Notify like using chatbots, text paging, email, etc.

## How to Use CheckPoint

After getting the code, set up the database and start the Phoenix application

```check_point % mix do ecto.drop, ecto.create, ecto.migrate, phx.server ```

First we need to create a contact.  A check requires a contact which would receive
a Notify if one is generated.

In GraphQL:

```
mutation {
  createContact(
    description: "Randy Bob", 
    type: "gql", 
    detail: "bob@example.com", 
    name: "bob") {
    id
  }
}

```

and check that this contact was created:

```
query{
 contact(name: "bob") {
  id
  detail
  description
  checks {
    id
  }
}}
```

And we can make changes, for example:

```
mutation{updateContact(id:1, detail: "bob@email.com") {
  id
  detail
}}
```

Now we can create a check.  The first probe that is provided is "green"
which always returns :ok

```
mutation {
  createCheck(
    probe: "green", 
    args: "n/a", 
    contact: "bob", 
    description: "global :ok") 
  {
    id
  }
}

```

You can refresh the query for bob or check directly for this check:

```
query{check(id: 1) {
  id
  probe
  args
  contact {
    id
    name
  }
  isAlive
  level
}}
```

Checks that always pass are good, but not as fun as checks that send Notify

```
mutation {
  createCheck(
    probe: "red", 
    args: "blech", 
    contact: "bob", 
    description: "global fail") 
  {
    id
  } }
```

And then we probably want to subscribe so we can see the Notify.  We can
either subscribe to the check itself:

```
subscription {
  checkNotify(id: 2) {
    id
    isAlive
    args
    probe
    contact {
      id
    }
    description
  }
}

```

or to the contact so we receive all Notify that are assigned to that contact:
```
subscription {
  contactNotify(id: 1) {
    id
    isAlive
    args
    probe
    description
  }
}
```

Now we need to wait 3 minutes until the Alarm goes off and triggers the Notify...

and that is how to use the GraphQL API to set up Watchers and get Notify.

Finally, a more useful alert is to monitor an HTTP URL and give an alert if it fails:

```
mutation {
  createCheck(
    probe: "http", 
    args: "http://google.com", 
    contact: "bob", 
    description: "Notify me if Google goes down") 
  {
    id
  }
}
```

While Google hopefully won't go down, this would also alert me if it cannot reach the URL
for some reason like my network going down.

##

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

