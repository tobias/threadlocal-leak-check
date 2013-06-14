(defproject threadlocal-leak-check "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [org.clojure/java.jmx "0.2.0"]]
  :plugins [[lein-ring "0.8.5"]]
  :ring {:handler threadlocal-leak-check.core/handler}
  :immutant {:context-path "/leak"}
  :profiles {:patched {:dependencies [[org.clojars.tcrawley/clojure "1.6.0-clearthreadlocals"]]}})
