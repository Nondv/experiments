(ns functional-oop.klass.method
  (:require [functional-oop.object :as object]))

(defn- call-message [method-name args]
  {:method method-name :args args})

(defn call-on-object [obj method-name & args]
  (object/send-msg obj (call-message method-name args)))

(defn for-message [method-map msg]
  (method-map (:method msg)))

(defn execute [method self state msg]
  (apply method self state (:args msg)))
