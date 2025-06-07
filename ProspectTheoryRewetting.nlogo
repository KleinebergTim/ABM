; Prospect Theory Rewetting Example
; This NetLogo model illustrates how farmers might decide to rewet their land
; using the decision framework of Prospect Theory.

globals [
  subsidy           ; payment received when rewetting
  rewet-cost        ; cost to rewet the land
  p-good            ; probability of a good crop if not rewetted
  profit-good       ; profit from a good crop
  profit-bad        ; profit from a bad crop
]

turtles-own [
  rewetted?                ; true if the farmer decided to rewet
  prospect-value-rewet     ; prospect value of rewetting
  prospect-value-crop      ; prospect value of continuing to crop
  decision                 ; current decision (true = rewet)
]

; setup procedures

to setup
  clear-all
  set subsidy 100
  set rewet-cost 50
  set p-good 0.6
  set profit-good 80
  set profit-bad -20
  create-farmers 50
  reset-ticks
end

; create farmers as turtles

to create-farmers [num]
  crt num [
    setxy random-xcor random-ycor
    set color green
    set rewetted? false
  ]
end

to go
  ask turtles [
    decide
    if rewetted? [ set color blue ] [ set color green ]
  ]
  tick
end

; decision procedure using Prospect Theory

to decide
  let gamma 0.61
  let alpha 0.88
  let beta 0.88
  let lambda 2.25
  let ref 0

  let v-crop-good value-function profit-good ref alpha beta lambda
  let v-crop-bad  value-function profit-bad  ref alpha beta lambda
  let w-good prob-weight p-good gamma
  let w-bad  prob-weight (1 - p-good) gamma
  set prospect-value-crop (v-crop-good * w-good) + (v-crop-bad * w-bad)

  let profit-rewet subsidy - rewet-cost
  set prospect-value-rewet value-function profit-rewet ref alpha beta lambda

  if prospect-value-rewet > prospect-value-crop [
    set rewetted? true
  ] [
    set rewetted? false
  ]
  set decision rewetted?
end

; value function of Prospect Theory

to-report value-function [x reference alpha beta lambda]
  let diff x - reference
  if diff >= 0 [ report diff ^ alpha ]
  report -lambda * ((- diff) ^ beta)
end

; probability weighting function

to-report prob-weight [p gamma]
  report (p ^ gamma) / ((p ^ gamma + ((1 - p) ^ gamma)) ^ (1 / gamma))
end

