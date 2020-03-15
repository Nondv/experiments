(ns functional-oop.cli
  (:require [functional-oop.klass :as klass]
            [functional-oop.klass.method :as method]
            [functional-oop.todo-list :refer [todo-list-klass]]))

(defn- request-string [prompt]
  (print prompt "")
  (flush)
  (read-line))

(defn- cli--print-list [self state]
  (let [blocker (promise)
        status-icon #(case %
                      :pending "-"
                      :done "+")
        print-entry #(println (status-icon (:status %)) (:title %))]
    (println "TODO list:")
    (method/call-on-object (:todo-list state)
                           :get-data
                           (fn [items]
                             (run! print-entry items)
                             (deliver blocker state)))
    @blocker
    state))

(defn- cli--complete [self state]
  (method/call-on-object (:todo-list state)
                         :complete
                         (Integer/parseInt (request-string "Index:")))
  state)

(defn- cli--add [self state]
  (method/call-on-object (:todo-list state)
                         :add
                         (request-string "Title:"))
  state)

(defn- cli--exit [self state]
  (deliver (:terminated state) true)
  nil)

(defn- cli--request-next-command [self state]
  (let [input (request-string "#")]
    (case input
      "add" (method/call-on-object self :add)
      "list"(method/call-on-object self :print-list)
      "complete" (method/call-on-object self :complete)
      "exit" (method/call-on-object self :exit)
      nil (method/call-on-object self :exit)
      (println "Unknown command")))
  (method/call-on-object self :request-next-command)
  state)

(defn- cli--start [self state]
  (method/call-on-object self :request-next-command)
  state)

(def cli-klass
  (klass/new-klass (fn [terminated-promise]
                     {:todo-list (klass/new-instance todo-list-klass)
                      :terminated terminated-promise})
                   {:add cli--add
                    :print-list cli--print-list
                    :complete cli--complete
                    :request-next-command cli--request-next-command
                    :exit cli--exit
                    :start cli--start}))
