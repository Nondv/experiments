(ns functional-oop.core
  (:gen-class)
  (:require [functional-oop.klass :as klass]
            [functional-oop.klass.method :as method]
            [functional-oop.cli :refer [cli-klass]]))

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (let [terminated? (promise)
        cli (klass/new-instance cli-klass terminated?)]
    (method/call-on-object cli :start)
    @terminated?))
