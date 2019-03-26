
(defparameter *estimate-new*
  '((Calais (0.0 0.0)) (Reims (25.0 5.0)) (Paris (30.0 8.33))
    (Nancy (50.0 11.66)) (Orleans (55.0 21.0)) (St-Malo (65.0 31.66))
    (Nantes (75.0 39.33)) (Brest (90.0 45.00)) (Nevers (70.0 15.0))
    (Limoges (100.0 35.0)) (Roenne (85.0 16.66)) (Lyon (105.0 18.33))
    (Toulouse (130.0 46.66)) (Avignon (135.0 31.66)) (Marseille (145.0 40.0))))

(defparameter *travel-cost-new*
  (make-problem
   :states *cities*
   :initial-state *origin*
   :f-h #'(lambda (state)
                  (f-h-price state *estimate-new*))
   :f-goal-test #'(lambda (node)
                          (f-goal-test node *destination* *mandatory*))
   :f-search-state-equal #'(lambda (node-1 node-2)
                                   (f-search-state-equal node-1 node-2 *mandatory*))
   :operators (list #'(lambda (node)
                              (navigate-canal-price (node-state node) *canals*))
                    #'(lambda (node)
                              (navigate-train-price
                               (node-state node) *trains* *forbidden*)))))
