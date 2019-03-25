;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Santiago Valderrabano Zamorano santiago.valderrabano@estudiante.uam.es
;; Martin de las Heras Moreno martin.delasheras@estudiante.uam.es
;; Pareja 4
;; Grupo 230
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;    Problem definition
;;
(defstruct problem
  states               ; List of states
  initial-state        ; Initial state
  f-h                  ; reference to a function that evaluates to the
  ; value of the heuristic of a state
  f-goal-test          ; reference to a function that determines whether
  ; a state fulfils the goal
  f-search-state-equal ; reference to a predictate that determines whether
  ; two nodes are equal, in terms of their search state
  operators)           ; list of operators (references to functions) to
; generate successors
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;    Node in search tree
;;
(defstruct node
  state           ; state label
  parent          ; parent node
  action          ; action that generated the current node from its parent
  (depth 0)       ; depth in the search tree
  (g 0)           ; cost of the path from the initial state to this node
  (h 0)           ; value of the heurstic
  (f 0))          ; g + h
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;    Actions
;;
(defstruct action
  name              ; Name of the operator that generated the action
  origin            ; State on which the action is applied
  final             ; State that results from the application of the action
  cost)             ; Cost of the action
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;    Search strategies
;;
(defstruct strategy
  name              ; name of the search strategy
  node-compare-p)   ; boolean comparison
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;    END: Define structures
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;    BEGIN: Define galaxy
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *cities* '(Calais Reims Paris Nancy Orleans
                                St-Malo Brest Nevers Limoges
                                Roenne Lyon Toulouse Avignon Marseille))

(defparameter *trains*
  '((Paris Calais (34.0 60.0))      (Calais Paris (34.0 60.0))
    (Reims Calais (35.0 70.0))      (Calais Reims (35.0 70.0))
    (Nancy Reims (35.0 55.0))       (Reims Nancy (35.0 55.0))
    (Paris Nancy (40.0 67.0))       (Nancy Paris (40.0 67.0))
    (Paris Nevers (48.0 75.0))      (Nevers Paris (48.0 75.0))
    (Paris Orleans (23.0 38.0))     (Orleans Paris (23.0 38.0))
    (Paris St-Malo (40.0 70.0))     (St-Malo Paris (40.0 70.0))
    (St-Malo Nantes (20.0 28.0))    (Nantes St-Malo (20.0 28.0))
    (St-Malo Brest (30.0 40.0))     (Brest St-Malo (30.0 40.0))
    (Nantes Brest (35.0 50.0))      (Brest Nantes (35.0 50.0))
    (Nantes Orleans (37.0 55.0))    (Orleans Nantes (37.0 55.0))
    (Nantes Toulouse (80.0 130.0))  (Toulouse Nantes (80.0 130.0))
    (Orleans Limoges (55.0 85.0))   (Limoges Orleans (55.0 85.0))
    (Limoges Nevers (42.0 60.0))    (Nevers Limoges (42.0 60.0))
    (Limoges Toulouse (25.0 35.0))  (Toulouse Limoges (25.0 35.0))
    (Toulouse Lyon (60.0 95.0))     (Lyon Toulouse (60.0 95.0))
    (Lyon Roenne (18.0 25.0))       (Roenne Lyon  (18.0 25.0))
    (Lyon Avignon (30.0 40.0))      (Avignon Lyon (30.0 40.0))
    (Avignon Marseille (16.0 25.0)) (Marseille Avignon (16.0 25.0))
    (Marseille Toulouse (65.0 120.0)) (Toulouse Marseille (65.0 120.0))))


(defparameter *canals*
  '((Reims Calais (75.0 15.0)) (Paris Reims (90.0 10.0))
    (Paris Nancy (80.0 10.0)) (Nancy reims (70.0 20.0))
    (Lyon Nancy (150.0 20.0)) (Nevers Paris (90.0 10.0))
    (Roenne Nevers (40.0 5.0)) (Lyon Roenne (40.0 5.0))
    (Lyon Avignon (50.0 20.0)) (Avignon Marseille (35.0 10.0))
    (Nantes St-Malo (40.0 15.0)) (St-Malo Brest (65.0 15.0))
    (Nantes Brest (75.0 15.0))))



(defparameter *estimate*
  '((Calais (0.0 0.0)) (Reims (25.0 0.0)) (Paris (30.0 0.0))
    (Nancy (50.0 0.0)) (Orleans (55.0 0.0)) (St-Malo (65.0 0.0))
    (Nantes (75.0 0.0)) (Brest (90.0 0.0)) (Nevers (70.0 0.0))
    (Limoges (100.0 0.0)) (Roenne (85.0 0.0)) (Lyon (105.0 0.0))
    (Toulouse (130.0 0.0)) (Avignon (135.0 0.0)) (Marseille (145.0 0.0))))

(defparameter *origin* 'Marseille)

(defparameter *destination* '(Calais))

(defparameter *forbidden*  '(Avignon))

(defparameter *mandatory* '(Paris))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN: Exercise 1 -- Evaluation of the heuristics
;;
;; Returns the value of the heuristics for a given state
;;
;;  Input:
;;    state: the current state (vis. the planet we are on)
;;    sensors: a sensor list, that is a list of pairs
;;                (state (time-est cost-est) )
;;             where the first element is the name of a state and the second
;;             a number estimating the costs to reach the goal
;;
;;  Returns:
;;    The cost (a number) or NIL if the state is not in the sensor list
;;
;;  It is necessary to define two functions: the first which returns the
;;  estimate of teh travel time, the second which returns the estimate of
;;  the cost of travel

(defun f-h-time (state sensors)
  (first (second (assoc state sensors))))

(defun f-h-price (state sensors)
  (second (second (assoc state sensors))))
;;
;; END: Exercise 1 -- Evaluation of the heuristic
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN: Exercise 2 -- Navigation operators
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; General navigation function
;;
;;  Returns the actions that can be carried out from the current state
;;
;;  Input:
;;    state:      the state from which we want to perform the action
;;    lst-edges:  list of edges of the graph, each element is of the
;;                form: (source destination (cost1 cost2))
;;    c-fun:      function that extracts the correct cost (time or price)
;;                from the pair that appears in the edge
;;    name:       name to be given to the actions that are created (see the
;;                action structure)
;;    forbidden-cities:
;;                list of the cities where we can't arrive by train
;;
;;  Returns
;;    A list of action structures with the origin in the current state and
;;    the destination in the states to which the current one is connected
;;
(defun navigate (state lst-edges cfun name &optional (forbidden '()))
  (remove nil (mapcar #'(lambda (x)
                          (if (equal state (first x))
                              (if (find (cadr x) forbidden)
                                  nil
                                (make-action
                                 :name name
                                 :origin state
                                 :final (cadr x)
                                 :cost (funcall cfun (caddr x))))
                            nil))
                lst-edges)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Navigation by canal
;;
;; This is a specialization of the general navigation function: given a
;; state and a list of canals, returns a list of actions to navigate
;; from the current city to the cities reachable from it by canal navigation.
;;
(defun navigate-canal-time (state canals)
  (navigate state canals #'first 'canal-time))

(defun navigate-canal-price (state canals)
  (navigate state canals #'second 'canal-price))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Navigation by train
;;
;; This is a specialization of the general navigation function: given a
;; state and a list of train lines, returns a list of actions to navigate
;; from the current city to the cities reachable from it by train.
;;
;; Note that this function takes as a parameter a list of forbidden cities.
;;
(defun navigate-train-time (state trains forbidden)
  (navigate state trains #'first 'train-time forbidden))

(defun navigate-train-price (state trains forbidden)
  (navigate state trains #'second 'train-price forbidden))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN: Exercise 3 -- Goal test
;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Goal test
;;
;;  Returns T or NIl depending on whether a path leads to a final state
;;
;;  Input:
;;    node:       node structure that contains, in the chain of parent-nodes,
;;                a path starting at the initial state
;;    destinations: list with the names of the destination cities
;;    mandatory:  list with the names of the cities that is mandatory to visit
;;
;;  Returns
;;    T: the path is a valid path to the final state
;;    NIL: invalid path: either the final city is not a destination or some
;;         of the mandatory cities are missing from the path.
;;


(defun evaluate-list (boolean-list)
  (if (null boolean-list)
      T
    (and (first boolean-list) (evaluate-list (rest boolean-list)))))

(defun exists-parent-path (candidate path-node)
  (if (null path-node)
      NIL
    (if (equal (node-state path-node) candidate)
        T
      (exists-parent-path candidate (node-parent path-node)))))


(defun f-goal-test (node destination mandatory)
  (if (find (node-state node) destination)
      (evaluate-list (mapcar #'(lambda(x)
                                 (exists-parent-path x node))
                       mandatory))
    NIL))

;;
;; END: Exercise 3 -- Goal test
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN: Exercise 4 -- Equal predicate for search states
;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Determines if two nodes are equivalent with respect to the solution
;; of the problem: two nodes are equivalent if they represent the same city
;, and if the path they contain includes the same mandatory cities.
;;  Input:
;;    node-1, node-2: the two nodes that we are comparing, each one
;;                    defining a path through the parent links
;;    mandatory:  list with the names of the cities that is mandatory to visit
;;
;;  Returns
;;    T: the two nodes are equivalent
;;    NIL: The nodes are not equivalent
;;

(defun equal-list (list1 list2)
  (if (or (null list1) (null list2))
      T
    (and (equal (first list1) (first list2))
         (equal-list (rest list1) (rest list2)))))

(defun f-search-state-equal (node-1 node-2 &optional (mandatory '()))
  (if (equal (node-state node-1) (node-state node-2))
      (equal-list
       (mapcar #'(lambda(x)
                   (exists-parent-path x node-1))
         mandatory)
       (mapcar #'(lambda(x)
                   (exists-parent-path x node-2))
         mandatory))
    NIL))

(defparameter node-nevers
   (make-node :state 'Nevers) )
(defparameter node-paris
   (make-node :state 'Paris :parent node-nevers))
(defparameter node-nancy
   (make-node :state 'Nancy :parent node-paris))
(defparameter node-reims
   (make-node :state 'Reims :parent node-nancy))
(defparameter node-calais
   (make-node :state 'Calais :parent node-reims))
(defparameter node-calais-2
   (make-node :state 'Calais :parent node-paris))

(f-search-state-equal node-calais node-calais-2 '()) ;-> T
(f-search-state-equal node-calais node-calais-2 '(Reims)) ;-> NIL
(f-search-state-equal node-calais node-calais-2 '(Nevers)) ;-> T
(f-search-state-equal node-nancy node-paris '()) ;-> NIL
;;
;; END: Exercise 4 -- Equal predicate for search states
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BEGIN: Exercise 5 -- Define the problem structure
;;
;;
;;  Note that the connectivity of the netowrk using canals and trains
;;  holes is implicit in the operators: there is a list of two
;;  operators, each one takes a single parameter: a state name, and
;;  returns a list of actions, indicating to which states one can move
;;  and at which cost. The lists of edges are placed as constants as
;;  the second parameter of the navigate operators.
;;
;;  There are two problems defined: one minimizes the travel time,
;;  the other minimizes the cost

(defparameter *travel-cheap*
  (make-problem
   :states *cities*
   :initial-state *origin*
   :f-h #'(lambda (state)
            (f-h-price state *estimate*))
   :f-goal-test #'(lambda (node)
                    (f-goal-test node *destination* *mandatory*))
   :f-search-state-equal #'(lambda (node-1 node-2)
                             (f-search-state-equal node-1 node-2 *mandatory*))
   :operators (list #'(lambda (node)
                        (navigate-canal-price (node-state node) *canals*))
                    #'(lambda (node)
                        (navigate-train-price
                         (node-state node) *trains* *forbidden*)))))

(defparameter *travel-fast*
  (make-problem
   :states *cities*
   :initial-state *origin*
   :f-h #'(lambda (state)
            (f-h-time state *estimate*))
   :f-goal-test #'(lambda (node)
                    (f-goal-test node *destination* *mandatory*))
   :f-search-state-equal #'(lambda (node-1 node-2)
                             (f-search-state-equal node-1 node-2 *mandatory*))
   :operators (list #'(lambda (node)
                        (navigate-canal-time
                         (node-state node) *canals*))
                    #'(lambda (node)
                        (navigate-train-time
                         (node-state node) *trains* *forbidden*)))))

;;
;;  END: Exercise 5 -- Define the problem structure
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN Exercise 6: Expand node
;;
;; The main function of this section is "expand-node", which receives
;; a node structure (the node to be expanded) and a problem structure.
;; The problem structure has a list of navigation operators, and we
;; are interested in the states that can be reached using anuy one of
;; them.
;;
;; So, in the expand-node function, we iterate (using mapcar) on all
;; the operators of the problem and, for each one of them, we call
;; expand-node-operator, to determine the states that can be reached
;; using that operator.
;;
;; The operator gives us back a list of actions. We iterate again on
;; this list of action and, for each one, we call expand-node-action
;; that creates a node structure with the node that can be reached
;; using that action.
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Creates a list with all the nodes that can be reached from the
;;  current one using all the operators in a given problem
;;
;;  Input:
;;    node:   the node structure from which we start.
;;    problem: the problem structure with the list of operators
;;
;;  Returns:
;;    A list (node_1,...,node_n) of nodes that can be reached from the
;;    given one
;;
(defun expand-node (node problem)
  (mapcar #'(lambda (node-action)
              (make-node
               :state (action-final node-action)
               :parent node
               :action node-action
               :g (+ (node-g node) (action-cost node-action))
               :h (funcall (problem-f-h problem) (action-final node-action))
               :f (+ (funcall (problem-f-h problem) (action-final node-action))
                     (+ (node-g node) (action-cost node-action)))))
    (append (funcall (first (problem-operators problem)) node)
            (funcall (second (problem-operators problem)) node))))

(defparameter node-nevers-ex6
   (make-node :state 'Nevers :depth 12 :g 10 :f 20))

(defparameter lst-nodes-ex6
  (expand-node node-nevers-ex6 *travel-fast*))

(print lst-nodes-ex6)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  BEGIN Exercise 7 -- Node list management
;;;
;;;  Merges two lists of nodes, one of them ordered with respect to a
;;;  given strategy, keeping the result ordered with respect to the
;;;  same strategy.
;;;
;;;  This is the idea: suppose that the ordering is simply the
;;;  ordering of natural numbers. We have a "base" list that is
;;;  already ordered, for example:
;;;      lst1 --> '(3 6 8 10 13 15)
;;;
;;;  and a list that is not necessarily ordered:
;;;
;;;      nord --> '(11 5 9 16)
;;;
;;;  the call (insert-nodes nord lst1 #'<) would produce
;;;
;;;    (3 5 6 8 9 10 11 13 15 16)
;;;
;;;  The functionality is divided in three functions. The first,
;;;  insert-node, inserts a node in a list keeping it ordered. The
;;;  second, insert-nodes, insert the nodes of the non-ordered list
;;;  into the ordered, one by one, so that the two lists are merged.
;;;  The last function, insert-node-strategy is a simple interface that
;;;  receives a strategy, extracts from it the comparison function,
;;;  and calls insert-nodes

(defun insert-node (node lst-nodes node-compare-p)
  (if (null lst-nodes)
      (list node)
    (if (funcall node-compare-p node (first lst-nodes))
        (cons node lst-nodes)
      (cons
       (first lst-nodes) (insert-node node
                                      (rest lst-nodes)
                                      node-compare-p)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Inserts a list of nodes in an ordered list keeping the result list
;; ordered with respect to the given comparison function
;;
;; Input:
;;    nodes: the (possibly unordered) node list to be inserted in the
;;           other list
;;    lst-nodes: the (ordered) list of nodes in which the given nodes
;;               are to be inserted
;;    node-compare-p: a function node x node --> 2 that returns T if the
;;                    first node comes first than the second.
;;
;; Returns:
;;    An ordered list of nodes which includes the nodes of lst-nodes and
;;    those of the list "nodes@. The list is ordered with respect to the
;;   criterion node-compare-p.
;;
(defun insert-nodes (nodes lst-nodes node-compare-p)
  (if (null nodes)
    lst-nodes
    (insert-nodes (rest nodes)
                  (insert-node
                  (first nodes) lst-nodes node-compare-p) node-compare-p)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Inserts a list of nodes in an ordered list keeping the result list
;; ordered with respect the given strategy
;;
;; Input:
;;    nodes: the (possibly unordered) node list to be inserted in the
;;           other list
;;    lst-nodes: the (ordered) list of nodes in which the given nodes
;;               are to be inserted
;;    strategy: the strategy that gives the criterion for node
;;              comparison
;;
;; Returns:
;;    An ordered list of nodes which includes the nodes of lst-nodes and
;;    those of the list "nodes@. The list is ordered with respect to the
;;    criterion defined in te strategy.
;;
;; Note:
;;   You will note that this function is just an interface to
;;   insert-nodes: it allows to call using teh strategy as a
;;   parameter; all it does is to "extract" the compare function and
;;   use it to call insert-nodes.
;;
(defun insert-nodes-strategy (nodes lst-nodes strategy)
  (insert-nodes nodes lst-nodes (strategy-node-compare-p strategy)))

(defun node-g-<= (node-1 node-2)
  (<= (node-g node-1)
      (node-g node-2)))

(defparameter *uniform-cost*
  (make-strategy
   :name 'uniform-cost
   :node-compare-p #'node-g-<=))

(defparameter node-paris-ex7
  (make-node :state 'Paris :depth 0 :g 0 :f 0) )

(defparameter node-nancy-ex7
  (make-node :state 'Nancy :depth 2 :g 50 :f 50) )

(defparameter node-marseille-ex6
   (make-node :state 'Marseille :depth 12 :g 10 :f 20) )

(defparameter lst-nodes-ex6
  (expand-node node-marseille-ex6 *travel-fast*))

(defparameter sol-ex7 (insert-nodes-strategy (list node-nancy-ex7)
                                             (list node-nevers)
                                             *uniform-cost*))
(defparameter node-nevers
  (make-node :state 'Nevers :depth 20 :g 10 :f 15))
(mapcar #'(lambda (x) (node-state x)) sol-ex7) ; -> (PARIS NANCY TOULOUSE)
(mapcar #'(lambda (x) (node-g x)) sol-ex7) ; -> (0 50 75)
;;
;;    END: Exercize 7 -- Node list management
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN: Exercise 8 -- Definition of the A* strategy
;;
;; A strategy is, basically, a comparison function between nodes to tell
;; us which nodes should be analyzed first. In the A* strategy, the first
;; node to be analyzed is the one with the smallest value of g+h
;;
(defparameter *A-star*
  (make-strategy
   :name 'A-star
   :node-compare-p #'(lambda (node-1 node-2)
                       (<= (node-f node-1) (node-f node-2)))))

;;
;; END: Exercise 8 -- Definition of the A* strategy
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;    BEGIN Exercise 9: Search algorithm
;;;
;;;    Searches a path that solves a given problem using a given search
;;;    strategy. Here too we have two functions: one is a simple
;;;    interface that extracts the relevant information from the
;;;    problem and strategy structure, builds an initial open-nodes
;;;    list (which contains only the starting node defined by the
;;;    state), and initial closed node list (the empty list), and calls
;;;    the auxiliary function.
;;;
;;;    The auxiliary is a recursive function that extracts nodes from
;;;    the open list, expands them, inserts the neighbors in the
;;;    open-list, and the expanded node in the closed list. There is a
;;;    caveat: with this version of the algorithm, a node can be
;;;    inserted in the open list more than once. In this case, if we
;;;    extract a node in the open list and the following two condition old:
;;;
;;;     the node we extract is already in the closed list (it has
;;;     already been expanded)
;;;       and
;;;     the path estimation that we have is better than the one we
;;;     obtain from the node in the open list
;;;
;;;     then we ignore the node.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Auxiliary search function (the one that actually does all the work
;;
;;  Input:
;;    problem: the problem structure from which we get the general
;;             information (goal testing function, action operatos, etc.
;;    open-nodes: the list of open nodes, nodes that are waiting to be
;;                visited
;;    closed-nodes: the list of closed nodes: nodes that have already
;;                  been visited
;;    strategy: the strategy that decide which node is the next extracted
;;              from the open-nodes list
;;
;;    Returns:
;;     NIL: no path to the destination nodes
;;     If these is a path, returns the node containing the final state.
;;
;;     Note that what is returned is quite a complex structure: the
;;     node contains in "parent" the node that comes before in the
;;     path, that contains another one in "parents" and so on until
;;     the initial one. So, what we have here is a rather complex
;;     nested structure that contains not only the final node but the
;;     whole path from the starting node to the final.
;;

(defun compare-g-nodes (problem node closed-nodes)
  (if (null closed-nodes)
    T
    (if (funcall (problem-f-search-state-equal problem) node (first closed-nodes))
        (if (< (node-g node) (node-g (first closed-nodes)))
          T
          nil)
        (compare-g-nodes problem node (rest closed-nodes)))))

(defun graph-search-aux (problem open-nodes closed-nodes strategy)
  (if (null open-nodes)
      nil
    (if (funcall (problem-f-goal-test problem) (first open-nodes))
        (first open-nodes)
      (if (not (compare-g-nodes problem (first open-nodes) closed-nodes))
          (graph-search-aux problem (rest open-nodes) closed-nodes strategy)
          (graph-search-aux problem
                          (insert-nodes-strategy
                            (expand-node (first open-nodes) problem)
                            (rest open-nodes)
                            strategy)
                          (cons (first open-nodes) closed-nodes)
                          strategy)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Interface function for the graph search.
;;
;;  Input:
;;    problem: the problem structure from which we get the general
;;             information (goal testing function, action operatos,
;;             starting node, heuristic, etc.
;;    strategy: the strategy that decide which node is the next extracted
;;              from the open-nodes list
;;
;;    Returns:
;;     NIL: no path to the destination nodes
;;     If these is a path, returns the node containing the final state.
;;
;;    See the graph-search-aux for the complete structure of the
;;    returned node.
;;    This function simply prepares the data for the auxiliary
;;    function: creates an open list with a single node (the source)
;;    and an empty closed list.
;;
(defun graph-search (problem strategy)
  (graph-search-aux problem
                    (list (make-node
                           :state (problem-initial-state problem)
                           :parent nil
                           :action nil
                           :g 0
                           :h (funcall (problem-f-h problem) (problem-initial-state problem))
                           :f (funcall (problem-f-h problem) (problem-initial-state problem))))
                    '()
                    strategy))

;
;  A* search is simply a function that solves a problem using the A* strategy
;
(defun a-star-search (problem)
  (graph-search problem *A-star*))

(graph-search *travel-cheap* *A-star*)
(a-star-search *travel-fast*)
;;
;; END: Exercise 9 -- Search algorithm
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;    BEGIN Exercise 10: Solution path
;;;
;;
;;  Funcion de solution-path.
;;
;;  Input:
;;    node: recibe el nodo final de una busqueda.
;;
;;    Returns:
;;     NIL: el nodo es nulo por lo que no hay solucion
;;     Una lista con las ciudades recorridas en orden.
;;

(defun solution-path (node)
  (if (null node)
      nil
    (if (null (node-parent node))
              (list (node-state node))
        (append (solution-path (node-parent node)) (list (node-state node))))))

; (defun solution-path (node)
;   (if (null node)
;       nil
;     (if (null (node-parent node))
;               (list (node-state node))
;         (cons (node-state node) (solution-path (node-parent node))))))

;;
;;  Funcion de action-sequence.
;;
;;  Input:
;;    node: recibe el nodo final de una busqueda.
;;
;;    Returns:
;;     NIL: el nodo es nulo por lo que no hay solucion
;;     Una lista con las acciones realizadas en el camino.
;;
; Visualize sequence of actions

(defun action-sequence (node)
  (if (null node)
      nil
    (if (null (node-parent (node-parent node)))
              (list (node-action node))
        (append (action-sequence (node-parent node)) (list (node-action node))))))

(solution-path nil) ;-> NIL

(solution-path (a-star-search *travel-fast*)) ; ->
; (MARSEILLE TOULOUSE LIMOGES ORLEANS PARIS CALAIS)

(solution-path (a-star-search *travel-cheap*))  ; ->
; (MARSEILLE TOULOUSE LIMOGES NEVERS PARIS REIMS CALAIS)

(action-sequence (a-star-search *travel-fast*))

(defparameter *origin* 'Marseille)

(defparameter *destination* '(Calais))

(defparameter *forbidden*  '(Paris))

(defparameter *mandatory* '(Paris))
; (defun action-sequence (node)
;   (if (null node)
;       nil
;     (if (null (node-parent (node-parent node)))
;               (list (node-action node))
;         (cons (node-action node) (action-sequence (node-parent node))))))
;;;
;;;    END Exercise 10: Solution path / action sequence
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;    BEGIN Exercise 11: depth-first / breadth-first
;;
;; Definicion de depth-first
;;    En la busqueda en profundidad, los nodos recien descubiertos tienen que ir
;;    antes en la lista de abiertos por lo que se devuelve T siempre en la comparacion.

(defun depth-first-node-compare-p (node-1 node-2)
  T)

(defparameter *depth-first*
  (make-strategy
   :name 'depth-first
   :node-compare-p #'depth-first-node-compare-p))

(defparameter *destination* '(Madrid))
(solution-path (graph-search *travel-fast* *depth-first*))

(defparameter *destination* '(Calais))
(defparameter *mandatory* '(Madrid))
;;
;; Definicion de breadth-first
;;    En la busqueda en anchura, los nodos recien descubiertos tienen que ir
;;    ultimos en la lista de abiertos por lo que se devuelve NIL siempre en la comparacion.

(defun breadth-first-node-compare-p (node-1 node-2)
 NIL)

(defparameter *breadth-first*
 (make-strategy
  :name 'breadth-first
  :node-compare-p #'breadth-first-node-compare-p))

(solution-path (graph-search *travel-cheap* *breadth-first*))
;;;
;;;
;;;    END Exercise 11: depth-first / breadth-first
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
