(ns functional-oop.object
  (:require [clojure.core.async :as async]))

(defn- datastructure [message-handler channel]
  {:message-handler message-handler
   :channel channel})

(defn- object-loop [obj state]
  (let [message (async/<!! (:channel obj))
        next-state ((:message-handler obj) obj state message)]
    (when-not (nil? next-state)
      (recur obj next-state))))

(defn init [state message-handler]
  (let [channel (async/chan 10)
        obj (datastructure message-handler channel)]
    (async/thread (object-loop obj state))
    obj))

(defn send-msg [obj msg]
  (async/>!! (:channel obj) msg))
