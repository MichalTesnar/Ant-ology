globals [
  food_down ;; food that has been put down already
  diffusion-rate
  evaporation-rate
  vision-radius
  salt
]

patches-own [
  chemical             ;; amount of chemical on this patch
  food                 ;; amount of food on this patch (0, 1, or 2)
  nest?                ;; true on nest patches, false elsewhere
  nest-scent           ;; number that is higher closer to the nest
  food-counter   ;; counter of how much food there is on the patch
  circleInfluence      ;; making range of effect of bomb
]

turtles-own [
 coordX ;; x coordinate of a place of interest
 coordY ;; y coordinate of a place of interest
 timesFoodPassed
 state ;; 'random', 'wiggleXY', "nest", "recruiting1", "recriuting2", "carried", "stationary"
]

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  set-default-shape turtles "ant"
  set food_down 0
  set diffusion-rate 50
  set evaporation-rate 10
  set vision-radius 3
  create-turtles population
  [ set size 3         ;; easier to see
    set color red      ;; red = not carrying food
    set coordX 0
    set coordY 0
    set state "random"
  ]
  setup-patches
  reset-ticks
end

to setup-patches
  ask patches [ ;; setup the colony nest
    setup-nest
    set chemical 0
    set circleInfluence patches in-radius 10
  ]
  setup-food
  ask patches [
    recolor-patch
  ]
end

to setup-nest  ;; patch procedure
  ;; set nest? variable to true inside the nest, false elsewhere
  set nest? (distancexy 0 0) < 5
  ;; spread a nest-scent over the whole world -- stronger near the nest
  set nest-scent 200 - distancexy 0 0
end

to setup-food
 let radius sqrt(food_amount / (blob_count * pi) ) ; n*pi*r^2 = food_amount -> r = sqrt(food_amount / (pi*n))
    ;; build blobs: not around the nest and not around the edges
  repeat blob_count [ ; blob times
    ; pick a spot away from the nest, away from the edges, and away from spaces which have food on them
    ask one-of patches with [(distancexy 0 0) > (5 + radius) and abs(pxcor) < max-pxcor - radius and abs(pycor) < max-pycor - radius and count patches in-radius (radius + 1) with [food > 0] = 0] [
      ;; save patch coordinates
      let save_x pxcor
      let save_y pycor
      ;; put down food within the radius as long as you have food to put down
      ask patches with [(distancexy save_x save_y) < radius] [
        if food_down < food_amount and food = 0 [
          set food food + 1 ; add food to the patch
          set food_down food_down + 1 ; increase global count
        ]
      ]
    ]
  ]
    ; put down remaining food on the existing food sources
    repeat (food_amount - food_down) [
    ask one-of patches with [food = 0 and count neighbors4 with [food > 0] != 0] [
          set food food + 1
          set food_down food_down + 1
          ]
    ]
end

to recolor-patch  ;; patch procedure
  ;; give color to nest and food sources
  ifelse nest?
  [ set pcolor violet ]
  [ ifelse food > 0
    [ if food = 1 [ set pcolor cyan ]]
    ;; scale color to show chemical concentration
    [ ifelse foraging_strategies = "pheromone trails" or foraging_strategies = "pheromone bomb" [
      set pcolor scale-color green chemical 0.1 5 ][
      set pcolor black
  ]] ]
end

;;;;;;;;;;;;;;;;;;;;;
;;; Go procedures ;;;
;;;;;;;;;;;;;;;;;;;;;

to go
  if all? patches [food = 0] and all? turtles [color = red or color = pink][
    stop
  ]
  ask turtles
  [ if who >= ticks [ stop ] ;; delay initial departure
    ifelse state != "nest"
    [ look-for-food ;; not carrying food? look for it
      if state = "carried" and (count my-links != 1)[
      break-link
      ]
      if distancexy coordX coordY < vision-radius and state = "wiggleXY" [ ;; The movement is once again randomised after the desired position is seen
        set state "random"
        break-link
      ]
      if state = "random" [
        set color red
        wiggle
        detect-food
      ]
      if state = "wiggleXY"[
        set color red - 2
        wiggle-to-xy
        detect-food
      ]
      if state = "recruiting1"[
        ifelse distancexy 0 0 < 5 [ ;; become stationary when in the nest
          set state "recruiting2"
        ][
          wiggle-to-0 ;; approach the nest
        ]
      ]
      if state = "recruiting2"[
        recruit-ant ;; send a signal to recruit a stationary ant in the nest
      ]
    ]
    [
      if state = "nest"[ ;; coming back to the nest with food
        return-to-nest ;; carrying food? take it back to nest
        if foraging_strategies = "prey chain transfer"[
          transfer-prey
        ]
      ]
    ]
    if state != "carried" and state != "recruiting2" and state != "stationary"[
      fd 1 ]
    if foraging_strategies = "tandem carrying"[
      assign-stationary ;; randomly walking ants can become stationary ants if they happen to stumble on the nest
    ]
  ]

  if foraging_strategies = "pheromone trails" [
    diffuse chemical (diffusion-rate / 100)
  ]
  ask patches [
    recolor-patch
    if foraging_strategies = "pheromone trails" or foraging_strategies = "pheromone bomb"[
     set chemical chemical * (100 - evaporation-rate) / 100  ;; slowly evaporate chemical
    ]
  ]
  tick
end

to break-link ;; assigns random state to itself and the linked ants
  set state "random"
  ask my-links [ask other-end[
    set state "random"
    ask my-out-links[
      die
    ]
  ]]
  ask my-links[
      die
  ]
end

to recruit-ant
  call-stationary ;; make the stationary ant appraoch self
  if any? turtles with [state = "stationary"] and distance (min-one-of turtles with [state = "stationary"] [distance myself]) <= 1[ ;; if a stationary ant is close
          ask min-one-of turtles with [state = "stationary"][distance myself][ ;; ask the ant to turn around and be carried
            rt 180
            set state "carried"
            set color green
          ]
          create-link-to min-one-of turtles with [state = "carried"][distance myself] [tie] ;; link to the stationary ant
          set state "wiggleXY" ;; go to the location of interest with the carried ant attached

        ]
end

to detect-food ;; sets heading of the ant towards the nearest food source in the vision radius
  if any? patches with [food > 0] and distance (min-one-of patches with [food > 0] [distance myself]) < vision-radius[
    set heading towards min-one-of patches with [food > 0] [distance myself]
  ]
end

to transfer-prey
  if random 100 < (100 / (timesFoodPassed + 2))[ ;; the chance of attempting to pass the carried food decreases with the number the food was passed
    if timesFoodPassed < 2 and state = "nest" [ ;; because of the small map size and high concentration of ants, we are limiting the initiative to approach ants at some point
      approach-ant
    ]
    if any? turtles with [state = "random"] and distance (min-one-of turtles with [state = "random"] [distance myself]) <= 1[ ;; another ant close enough to pass food
      ask min-one-of turtles with [state = "random"][distance myself][
        set color orange + 1
        set coordX xcor
        set coordY ycor
        set state "nest"
        set timesFoodPassed ([timesFoodPassed] of myself) + 1
;        show timesFoodPassed
        rt 180
      ]
      set color red - 2
      rt 180
      set state "wiggleXY"
    ]
  ]
end

to approach-ant
  if any? turtles with [state = "random"] and distance (min-one-of turtles with [state = "random"] [distance myself]) < vision-radius[ ;; is there a wandering ant in the vision radius?
    set heading towards min-one-of turtles with [state = "random"][distance myself] ;; turn towards that ant
    ask min-one-of turtles with [state = "random" ][distance myself][
      set heading towards myself ;; turn that ant towards myself
    ]
  ]
end

to call-stationary ;; makes a stationary ant approach the caller
  if any? turtles with [state = "stationary"][
    set heading towards min-one-of turtles with [state = "stationary"][distance myself]
    ask min-one-of turtles with [state = "stationary" ][distance myself][
      set heading towards myself
      fd 1
    ]
  ]
end

to assign-stationary
  if nest? and state = "random" and count turtles with [state = "stationary"] < count turtles / 20[
      set state "stationary"
      set color pink
    ]
end

to return-to-nest  ;; turtle procedure
  ifelse nest?
  [ ;; drop food and head out again
    set color red
    rt 180
    if state = "nest"[
        set state "wiggleXY"
      if foraging_strategies = "tandem carrying"[
        if count turtles with [state = "stationary"] < count turtles / 10[
          set state "stationary"
          set color pink
      ]]
    ]
  ]
  [ if foraging_strategies = "pheromone trails"[
      set chemical chemical + 60]  ;; drop some chemical
    wiggle-to-0 ]         ;; head toward the nest
end

to look-for-food  ;; turtle procedure
  if food > 0
  [
    break-link
    ifelse foraging_strategies = "tandem carrying" and count (patches with [food > 0 and distance myself < vision-radius]) > 2 and random 100 < 75
    and count other turtles with [state = "recruiting2" or state = "recruiting1"] < count turtles with [state = "stationary"] * 2[
      set state "recruiting1"
      set color blue
      set coordX xcor
      set coordY ycor

    ][
      if state != "carried"[
        if foraging_strategies = "pheromone bomb"[
          deploy-bomb
        ]
        set color orange + 1     ;; pick up food
        set food food - 1        ;; and reduce the food source
        rt 180                   ;; and turn around
        set coordX xcor
        set coordY ycor
        set state "nest"
        set timesFoodPassed 0
        stop ]]]
  ;; go in the direction where the chemical smell is strongest
  if foraging_strategies = "pheromone trails" or foraging_strategies = "pheromone bomb"[
    if (chemical >= 0.05) and (chemical < 2)[ uphill-chemical ]
  ]
end

to deploy-bomb
;  print "bomb deployed"
  ask patches in-radius 5 [
    set chemical 60
    ask circleInfluence [
      set chemical 20 - distance myself
    ]
  ]
end

;; sniff left and right, and go where the strongest smell is
to uphill-chemical  ;; turtle procedure
  let scent-ahead chemical-scent-at-angle   0
  let scent-right chemical-scent-at-angle  45
  let scent-left  chemical-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end

;; sniff left and right, and go where the strongest smell is
to uphill-nest-scent  ;; turtle procedure
  let scent-ahead nest-scent-at-angle   0
  let scent-right nest-scent-at-angle  45
  let scent-left  nest-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end

to wiggle-to-0  ;; turtle procedure
  let direction (towardsxy 0 0)
  rt random 20
  lt random 20

  if subtract-headings direction heading  > 30 [
    set heading (direction + 330) mod 360
  ]
  if subtract-headings direction heading  < -30[
    set heading (direction + 30) mod 360
  ]
  if not can-move? 1 [ rt 180 ]
end

to wiggle  ;; turtle procedure
  rt random 40
  lt random 40
  if not can-move? 1 [ rt 180 ]
end

to wiggle-to-xy
  let direction (towardsxy coordX coordY)
  rt random 40
  lt random 40

  if subtract-headings direction heading  > 75 [
    set heading (direction + 285) mod 360
  ]
  if subtract-headings direction heading  < -75[
    set heading (direction + 75) mod 360
  ]
  if not can-move? 1 [ rt 180 ]
end

to-report nest-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [nest-scent] of p
end

to-report chemical-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [chemical] of p
end
@#$#@#$#@
GRAPHICS-WINDOW
257
10
762
516
-1
-1
7.0
1
10
1
1
1
0
0
0
1
-35
35
-35
35
1
1
1
ticks
30.0

BUTTON
46
71
126
104
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
136
71
211
104
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
31
36
221
69
population
population
0.0
200.0
100.0
1.0
1
NIL
HORIZONTAL

CHOOSER
43
205
209
250
foraging_strategies
foraging_strategies
"solitary foraging" "prey chain transfer" "tandem carrying" "pheromone trails" "pheromone bomb"
1

SLIDER
39
118
211
151
food_amount
food_amount
0
500
300.0
1
1
NIL
HORIZONTAL

SLIDER
38
160
210
193
blob_count
blob_count
1
200
51.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

Final project for Agent Technology Practical 2023 made by Laura, Viki, Wojtek & Michal, all students of Artificial Intelligence at the Rijksuniversiteit Groningen.

## HOW IT WORKS

When an ant finds a piece of food, it carries the food back to the nest. Depending on the selected strategy, the ants cooperate to collect the food.

## HOW TO USE IT
Choose the amount of food to be displayed and the number of blobs it is suppoed to be in. Then click the SETUP button to set up the ant nest (in violet, at center) and piles of food. Select a foraging strategy from the list. Then click 'Run' and observe the ants do what they do!

If you want to change the number of ants, move the POPULATION slider before pressing SETUP.

## Credits
This model is based on

Wilensky, U. (1997).  NetLogo Ants model.  http://ccl.northwestern.edu/netlogo/models/Ants.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="pheromone trails" repetitions="1" runMetricsEveryStep="false">
    <setup>random-seed food_amount + 1000 * blob_count + salt
setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>ticks</metric>
    <enumeratedValueSet variable="foraging_strategies">
      <value value="&quot;pheromone trails&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="blob_count" first="1" step="2" last="51"/>
    <steppedValueSet variable="food_amount" first="30" step="15" last="300"/>
    <enumeratedValueSet variable="population">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="salt" first="0" step="60000" last="540000"/>
  </experiment>
  <experiment name="solitary foraging" repetitions="1" runMetricsEveryStep="false">
    <setup>random-seed food_amount + 1000 * blob_count + salt
setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>ticks</metric>
    <enumeratedValueSet variable="foraging_strategies">
      <value value="&quot;solitary foraging&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="blob_count" first="1" step="2" last="51"/>
    <steppedValueSet variable="food_amount" first="30" step="15" last="300"/>
    <enumeratedValueSet variable="population">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="salt" first="0" step="60000" last="540000"/>
  </experiment>
  <experiment name="prey chain transfer" repetitions="1" runMetricsEveryStep="false">
    <setup>random-seed food_amount + 1000 * blob_count + salt
setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>ticks</metric>
    <enumeratedValueSet variable="foraging_strategies">
      <value value="&quot;prey chain transfer&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="blob_count" first="1" step="2" last="51"/>
    <steppedValueSet variable="food_amount" first="30" step="15" last="300"/>
    <enumeratedValueSet variable="population">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="salt" first="0" step="60000" last="540000"/>
  </experiment>
  <experiment name="tandem carrying" repetitions="1" runMetricsEveryStep="false">
    <setup>random-seed food_amount + 1000 * blob_count + salt
setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>ticks</metric>
    <enumeratedValueSet variable="foraging_strategies">
      <value value="&quot;tandem carrying&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="blob_count" first="1" step="2" last="51"/>
    <steppedValueSet variable="food_amount" first="30" step="15" last="300"/>
    <enumeratedValueSet variable="population">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="salt" first="0" step="60000" last="540000"/>
  </experiment>
  <experiment name="pheromone bomb" repetitions="1" runMetricsEveryStep="false">
    <setup>random-seed food_amount + 1000 * blob_count + salt
setup</setup>
    <go>go</go>
    <metric>ticks</metric>
    <enumeratedValueSet variable="foraging_strategies">
      <value value="&quot;pheromone bomb&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="blob_count" first="1" step="2" last="51"/>
    <steppedValueSet variable="food_amount" first="30" step="15" last="300"/>
    <enumeratedValueSet variable="population">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="salt" first="0" step="60000" last="540000"/>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
