(ns functional-oop.klass-test
  (:require [clojure.test :refer :all]
            [functional-oop.klass :as klass]
            [functional-oop.klass.method :as method]))

(deftest string-builder-test
  (testing "Same string-builder test but class-based"
    (let [constructor (fn [& strings] {:strings (into [] strings)})
          string-builder-klass (klass/new-klass
                                constructor
                                {:add (fn [_ state string]
                                        (update state :strings conj string))
                                 :build (fn [_ state promise-obj]
                                          (deliver promise-obj
                                                   (apply str (:strings state)))
                                          state)
                                 :free (constantly nil)})]
      (testing "instantiated without arguments"
        (let [instance (klass/new-instance string-builder-klass)]
          (method/call-on-object instance :add "abc")
          (method/call-on-object instance :add "def")
          (let [result (promise)]
            (method/call-on-object instance :build result)
            (is (= "abcdef" @result)))
          (method/call-on-object instance :free)))
      (testing "instantiated with arguments"
        (let [instance (klass/new-instance string-builder-klass "ghi" "jkl")]
          (method/call-on-object instance :add "haha")
          (let [result (promise)]
            (method/call-on-object instance :build result)
            (is (= "ghijklhaha" @result)))
          (method/call-on-object instance :free))))))
