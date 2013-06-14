# threadlocal-leak-check

A sample app that demonstrates the efficacy of the patch for
http://dev.clojure.org/jira/browse/CLJ-1125.

It includes a script that installs Tomcat, creates an uberwar, then
deploys/undeploys it in a loop, printing permgen and loaded class
stats for each run.

When ran against Clojure 1.5.1, permgen is exhausted in 4-6 loop
invocations. When ran against a patched version of 1.6.0, it runs
indefinitely.

## Usage

You'll need `wget`, `zip`, `unzip`, and `lein` (>= 2.2.0) in your
path.

The `bin/run.sh` script will setup Tomcat and start the deploy
loop. To run against an unpatched 1.5.1:
   
    $ ./bin/run.sh
    
To run against a patched 1.6.0-master:

    $ ./bin/run.sh patched
    
This will use `[org.clojars.tcrawley/clojure "1.6.0-clearthreadlocals"]`, which is
https://github.com/clojure/clojure/commit/ef00c7cffad10e6104d333f7f71a29163b06cd0a +
the `threadlocal-removal-tcrawley-2013-06-14.diff` patch from CLJ-1125.

In addition to watching memory stats in the output of the script, you
should also `tail -f target/tomcat/logs/catalina.<date>.log` to watch
for ThreadLocal leak warnings and OOM exceptions.

Watching the permgen chart in VisualVM is also handy.

## License

Copyright © 2013 Toby Crawley

Distributed under the Eclipse Public License, the same as Clojure.
