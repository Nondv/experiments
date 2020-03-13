(ns functional-oop.object-test
  (:require [clojure.test :refer :all]
            [functional-oop.object :as object]))

(deftest string-builder-test
  (let [message-handler (fn [self state msg]
                          (case (:method msg)
                            :add (update state :strings conj (:str msg))
                            :add-twice (let [new-msg {:method :add, :str (:str msg)}]
                                         (object/send-msg self new-msg)
                                         (object/send-msg self new-msg)
                                         (when (:promise msg)
                                           (deliver (:promise msg) true))
                                         state)
                            :reset (assoc state :strings [])
                            :build (do
                                     ((:fn msg) (apply str (:strings state)))
                                     state)
                            :free nil
                            state))
        builder (object/init {:strings []} message-handler)]


    (testing "side effects"
      (object/send-msg builder {:method :add, :str "abc"})
      (object/send-msg builder {:method :add, :str "def"})
      (object/send-msg builder {:method :add, :str "ghi"})
      (let [res (promise)]
        (object/send-msg builder {:method :build, :fn #(deliver res %)})
        (is (= "abcdefghi" @res))))

    (object/send-msg builder {:method :reset})

    (testing "sending messages to self"
      (let [block (promise)] ; We need to control execution order (cuz of the paralellism)
        (object/send-msg builder {:method :add-twice, :promise block, :str "ha"})
        @block)
      (let [res (promise)]
        (object/send-msg builder {:method :build, :fn #(deliver res %)})
        (is (= "haha" @res))))

    (object/send-msg builder {:method :free})))
