Invoking rails-crawler
======================

rails-crawler takes two arguments: the path to the Rails application and the
site-relative start URL:

    ruby crawl.rb /path/to/app /

If your start URL is a static page, you need to specify it explicitly:

    ruby crawl.rb /path/to/app /index.html


How it works
============

rails-crawler uses the same interface as Rails integration tests to query URLs
and retrieve their responses. Thus, it does not actually use the network at
all.

Beginning with a GET request to the start URL, the site is walked in a
depth-first fashion, following anchors and form actions, until all reachable
paths have been processed. Each path is matched to its corresponding route
(except static resources or non-existent pages which are handled separately);
routes which are never hit are marked as "unused".

Currently, the application is loaded in the *production* environment, but this
will probably change in the future.


Current limitations
===================

rails-crawler currently only crawls through *anonymously-accessible* paths. If
they require the user to log in, they will be marked as unused. Forms are
submitted with no post variables, and so most will usually fail with HTTP
error 422.


TODO list
=========

 * Follow href attributes in tags like img and link
 * The ability to authenticate with sites
 * A way to submit valid form data
 * Look in the config/ directory for a configuration file


License
=======

rails-crawler is released under the GPL.