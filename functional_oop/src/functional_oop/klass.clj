(ns functional-oop.klass
  (:require [functional-oop.object :as object]
            [functional-oop.klass.method :as method]))

(defn- message-handler [method-map]
  (fn [self state msg]
    ;; Ignore invalid messages (at least for now)
    (when-let [method (method/for-message method-map msg)]
      (method/execute method self state msg))))


(defn- instantiate [klass state promise-obj & args]
  (let [{:keys [constructor method-map]} state
        instance (object/init (apply constructor args)
                              (message-handler method-map))]
    (update state :instances conj @(deliver promise-obj instance))))

(defn new-klass [constructor method-map]
  (object/init {:method-map method-map
                :constructor constructor
                :instances []}
               (message-handler {:new instantiate})))

(defn new-instance
  "Calls :new method on a klass and blocks until the instance is ready. Returns the instance"
  [klass & constructor-args]
  (let [instance-promise (promise)]
    (apply method/call-on-object klass :new instance-promise constructor-args)
    @instance-promise))
