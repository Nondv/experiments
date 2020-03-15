(ns functional-oop.todo-list
  (:require [functional-oop.klass :as klass]
            [functional-oop.klass.method :as method]))

(def todo-item-klass
  (klass/new-klass
   (fn [title]
     {:status :pending
      :title title})
   {:complete (fn [self state] (assoc state :status :done))
    :get-data (fn [self state result-promise]
                @(deliver result-promise state))}))

(defn- todo-list--complete [self state index]
  (when-let [item ((:items state) index)]
    (method/call-on-object item :complete)
    state))

(defn- todo-list--add [self state title]
  (let [item (klass/new-instance todo-item-klass title)]
    (update state :items conj item)))

(defn- todo-list--get-data [self state callback]
  (let [items (:items state)
        item-promises (map (fn [_] (promise)) items)
        item-promise-pairs (map vector items item-promises)]
    (run! #(method/call-on-object (first %) :get-data (second %))
          item-promise-pairs)
    (callback (map deref item-promises))
    state))

(def todo-list-klass
  (klass/new-klass (fn [] {:items []})
                   {:add todo-list--add
                    :complete todo-list--complete
                    :get-data todo-list--get-data}))
