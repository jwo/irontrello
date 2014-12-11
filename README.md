IronTrello
===========

Why?
----

* Make posting links to people's trello boards easy

How?
---

1. Get Started (see below)
2. `ruby cli.rb links-new http://clown.fart`
3. ...
4. profit


Get Started
----------

1. Clone this repo
2. `cd irontrello`
3. `ruby cli.rb api-start`
4. Copy the KEY and run:
5. `ruby cli.rb api-save THEKEY`
4. `ruby cli.rb auth-start`
5. Authorize and copy the key that shows
5. `ruby cli.rb auth-save THEKEY`
6. `ruby cli.rb boards-new`
7. Take the IDS of the boards you want to post links to and run (for each):
7. `ruby cli.rb boards-save BOARDID`
