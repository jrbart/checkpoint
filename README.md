# CheckPoint

A monitoring service to track the status of services that you depend on!

Contacts are checks are added like this:

```
alias CheckPoint.Checks

Checks.create_contact(%{
    name: "bruce",
    description: "Bruce Boss",
    type: "email",
    detail: "bb@email.com"
})

Checks.create_check(%{
        description: "localhost",
        args: "localhost",
        opts: "",
        contact_id: 1
})
```

The application will run the test repeatedly (default every 5 minutes) and
notify the contact if the test fails 3 times in a row.  On the first failure
it will decrease the interval to 1/10th of the initial value.

## Take-aways

This project demonstrates the use of GenServers, Tasks, and GraphQL along with Ecto

