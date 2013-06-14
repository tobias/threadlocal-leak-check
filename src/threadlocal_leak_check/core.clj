(ns threadlocal-leak-check.core
  (:require [clojure.java.jmx :as jmx]))

(defn meminfo []
  (format "permgen: %s\nloaded classes: %s\n"
          (pr-str (:PeakUsage (jmx/mbean "java.lang:type=MemoryPool,name=PS Perm Gen")))
          (pr-str (select-keys (jmx/mbean "java.lang:type=ClassLoading")
                               [:TotalLoadedClassCount :LoadedClassCount :UnloadedClassCount]))))

(def ^:dynamic *foo* 1)
(def r (ref nil))

(defn handler [request]
  ;; deref a dynamic var
  *foo*
  
  ;; explicitly grab the bindings
  (get-thread-bindings)
  
  ;; try nested transactions
  (dosync
   (dosync
    (ref-set r "whatever")))
  
  ;; exercise futures and agents, since they do binding conveyance
  @(future-call (constantly 1))
  (send (agent nil) (constantly 1))

  ;; shutdown the agent pool, since leaving it up will definitely
  ;; cause leaks
  (shutdown-agents)
  
  {:status 200
   :headers {"Content-Type" "text/plain"}
   :body (format "Clojure version: %s\n%s"
                 (clojure-version)
                 (meminfo))})

