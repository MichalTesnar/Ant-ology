extensions [sound] ;extend this, if you want

globals [
  food_down ;; food that has been put down already
  max-fireworks
  initial-x-vel
  initial-y-vel
  gravity
  fragments
  trails?
  fade-amount
  diffusion-rate
  evaporation-rate
  vision-radius
  salt
]

breed [ rockets rocket ]
breed [ frags frag ]


rockets-own [
  terminal-y-vel  ; velocity at which rocket will explode
]

frags-own [
  dim             ; used for fading particles
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
 col             ; sets color of an explosion particle
 x-vel           ; x-velocity
 y-vel           ; y-velocity
 state ;; 'random', 'wiggleXY', "nest", "recruiting1", "recriuting2", "carried", "stationary"
]

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  sound:stop-music
  sound:play-sound-later "sounds/0_sound.wav" 0
  sound:play-sound-later "sounds/1_sound.wav" 1
  sound:play-sound-later "sounds/2_sound.wav" 2
  sound:play-sound-later "sounds/3_sound.wav" 3
  sound:play-sound-later "sounds/4_sound.wav" 4
  sound:play-sound-later "sounds/5_sound.wav" 5
  sound:play-sound-later "sounds/6_sound.wav" 6
  sound:play-sound-later "sounds/7_sound.wav" 7
  sound:play-sound-later "sounds/8_sound.wav" 8
  sound:play-sound-later "sounds/9_sound.wav" 9
  sound:play-sound-later "sounds/10_sound.wav" 10
  sound:play-sound-later "sounds/11_sound.wav" 11
  sound:play-sound-later "sounds/12_sound.wav" 12
  sound:play-sound-later "sounds/13_sound.wav" 13
  sound:play-sound-later "sounds/14_sound.wav" 14
  sound:play-sound-later "sounds/15_sound.wav" 15
  sound:play-sound-later "sounds/16_sound.wav" 16
  sound:play-sound-later "sounds/17_sound.wav" 17
  sound:play-sound-later "sounds/18_sound.wav" 18
  sound:play-sound-later "sounds/19_sound.wav" 19
  sound:play-sound-later "sounds/20_sound.wav" 20
  sound:play-sound-later "sounds/21_sound.wav" 21
  sound:play-sound-later "sounds/22_sound.wav" 22
  sound:play-sound-later "sounds/23_sound.wav" 23
  sound:play-sound-later "sounds/24_sound.wav" 24
  sound:play-sound-later "sounds/25_sound.wav" 25
  sound:play-sound-later "sounds/26_sound.wav" 26
  sound:play-sound-later "sounds/27_sound.wav" 27
  sound:play-sound-later "sounds/28_sound.wav" 28
  sound:play-sound-later "sounds/29_sound.wav" 29
  sound:play-sound-later "sounds/30_sound.wav" 30
  sound:play-sound-later "sounds/31_sound.wav" 31
  sound:play-sound-later "sounds/32_sound.wav" 32
  sound:play-sound-later "sounds/33_sound.wav" 33
  sound:play-sound-later "sounds/34_sound.wav" 34
  sound:play-sound-later "sounds/35_sound.wav" 35
  sound:play-sound-later "sounds/36_sound.wav" 36
  sound:play-sound-later "sounds/37_sound.wav" 37
  sound:play-sound-later "sounds/38_sound.wav" 38
  sound:play-sound-later "sounds/39_sound.wav" 39
  sound:play-sound-later "sounds/40_sound.wav" 40
  sound:play-sound-later "sounds/41_sound.wav" 41
  sound:play-sound-later "sounds/42_sound.wav" 42
  sound:play-sound-later "sounds/43_sound.wav" 43
  sound:play-sound-later "sounds/44_sound.wav" 44
  sound:play-sound-later "sounds/45_sound.wav" 45
  sound:play-sound-later "sounds/46_sound.wav" 46
  sound:play-sound-later "sounds/47_sound.wav" 47
  sound:play-sound-later "sounds/48_sound.wav" 48
  sound:play-sound-later "sounds/49_sound.wav" 49
  sound:play-sound-later "sounds/50_sound.wav" 50
  sound:play-sound-later "sounds/51_sound.wav" 51
  sound:play-sound-later "sounds/52_sound.wav" 52
  sound:play-sound-later "sounds/53_sound.wav" 53
  sound:play-sound-later "sounds/54_sound.wav" 54
  sound:play-sound-later "sounds/55_sound.wav" 55
  sound:play-sound-later "sounds/56_sound.wav" 56
  sound:play-sound-later "sounds/57_sound.wav" 57
  sound:play-sound-later "sounds/58_sound.wav" 58
  sound:play-sound-later "sounds/59_sound.wav" 59
  sound:play-sound-later "sounds/60_sound.wav" 60
  sound:play-sound-later "sounds/61_sound.wav" 61
  sound:play-sound-later "sounds/62_sound.wav" 62
  sound:play-sound-later "sounds/63_sound.wav" 63
  sound:play-sound-later "sounds/64_sound.wav" 64
  sound:play-sound-later "sounds/65_sound.wav" 65
  sound:play-sound-later "sounds/66_sound.wav" 66
  sound:play-sound-later "sounds/67_sound.wav" 67
  sound:play-sound-later "sounds/68_sound.wav" 68
  sound:play-sound-later "sounds/69_sound.wav" 69
  sound:play-sound-later "sounds/70_sound.wav" 70
  sound:play-sound-later "sounds/71_sound.wav" 71
  sound:play-sound-later "sounds/72_sound.wav" 72
  sound:play-sound-later "sounds/73_sound.wav" 73
  sound:play-sound-later "sounds/74_sound.wav" 74
  sound:play-sound-later "sounds/75_sound.wav" 75
  sound:play-sound-later "sounds/76_sound.wav" 76
  sound:play-sound-later "sounds/77_sound.wav" 77
  sound:play-sound-later "sounds/78_sound.wav" 78
  sound:play-sound-later "sounds/79_sound.wav" 79
  sound:play-sound-later "sounds/80_sound.wav" 80
  sound:play-sound-later "sounds/81_sound.wav" 81
  sound:play-sound-later "sounds/82_sound.wav" 82
  sound:play-sound-later "sounds/83_sound.wav" 83
  sound:play-sound-later "sounds/84_sound.wav" 84
  sound:play-sound-later "sounds/85_sound.wav" 85
  sound:play-sound-later "sounds/86_sound.wav" 86
  sound:play-sound-later "sounds/87_sound.wav" 87
  sound:play-sound-later "sounds/88_sound.wav" 88
  sound:play-sound-later "sounds/89_sound.wav" 89
  sound:play-sound-later "sounds/90_sound.wav" 90
  sound:play-sound-later "sounds/91_sound.wav" 91
  sound:play-sound-later "sounds/92_sound.wav" 92
  sound:play-sound-later "sounds/93_sound.wav" 93
  sound:play-sound-later "sounds/94_sound.wav" 94
  sound:play-sound-later "sounds/95_sound.wav" 95
  sound:play-sound-later "sounds/96_sound.wav" 96
  sound:play-sound-later "sounds/97_sound.wav" 97
  sound:play-sound-later "sounds/98_sound.wav" 98
  sound:play-sound-later "sounds/99_sound.wav" 99
  sound:play-sound-later "sounds/100_sound.wav" 100
  sound:play-sound-later "sounds/101_sound.wav" 101
  sound:play-sound-later "sounds/102_sound.wav" 102
  sound:play-sound-later "sounds/103_sound.wav" 103
  sound:play-sound-later "sounds/104_sound.wav" 104
  sound:play-sound-later "sounds/105_sound.wav" 105
  sound:play-sound-later "sounds/106_sound.wav" 106
  sound:play-sound-later "sounds/107_sound.wav" 107
  sound:play-sound-later "sounds/108_sound.wav" 108
  sound:play-sound-later "sounds/109_sound.wav" 109
  sound:play-sound-later "sounds/110_sound.wav" 110
  sound:play-sound-later "sounds/111_sound.wav" 111
  sound:play-sound-later "sounds/112_sound.wav" 112
  sound:play-sound-later "sounds/113_sound.wav" 113
  sound:play-sound-later "sounds/114_sound.wav" 114
  sound:play-sound-later "sounds/115_sound.wav" 115
  sound:play-sound-later "sounds/116_sound.wav" 116
  sound:play-sound-later "sounds/117_sound.wav" 117
  sound:play-sound-later "sounds/118_sound.wav" 118
  sound:play-sound-later "sounds/119_sound.wav" 119
  sound:play-sound-later "sounds/120_sound.wav" 120
  sound:play-sound-later "sounds/121_sound.wav" 121
  sound:play-sound-later "sounds/122_sound.wav" 122
  sound:play-sound-later "sounds/123_sound.wav" 123
  sound:play-sound-later "sounds/124_sound.wav" 124
  sound:play-sound-later "sounds/125_sound.wav" 125


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
    launch-fireworks
    stop
  ]

  let shapesOptions ["poweredUpAntV1" "poweredUpAntV2" "poweredUpAntV3" "poweredUpAntV4" "poweredUpAntV5" "poweredUpAntV6"]

  ask turtles [
    set shape one-of shapesOptions
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

to launch-fireworks
  clear-all
  reset-ticks
  set-default-shape turtles "circle"
  set max-fireworks 20
  set initial-x-vel 1.2
  set initial-y-vel 1.2
  set gravity 0.5
  set fragments 20
  set trails? true
  set fade-amount 2
  init-rockets
  repeat 50 [
    ask turtles [
      projectile-motion
      ]
    tick
  ]
end


to init-rockets
  clear-drawing
  create-rockets max-fireworks [
    setxy random-xcor min-pycor
    set x-vel ((random-float (2 * initial-x-vel)) - (initial-x-vel))
    set y-vel ((random-float initial-y-vel) + initial-y-vel * 2)
    set col one-of base-colors
    set color (col + 2)
    set size 2
    set terminal-y-vel (random-float 4.0) ; at what speed does the rocket explode?
  ]
end

; This function simulates the actual free-fall motion of the turtles.
; If a turtle is a rocket it checks if it has slowed down enough to explode.
to projectile-motion ; turtle procedure
  set y-vel (y-vel - (gravity / 5))
  set heading (atan x-vel y-vel)
  let move-amount (sqrt ((x-vel ^ 2) + (y-vel ^ 2)))
  if not can-move? move-amount [ die ]
  fd (sqrt ((x-vel ^ 2) + (y-vel ^ 2)))

  ifelse (breed = rockets) [
    if (y-vel < terminal-y-vel) [
      explode
      die
    ]
  ] [
    fade
  ]
end

; This is where the explosion is created.
; EXPLODE calls hatch a number of times indicated by the slider FRAGMENTS.
to explode ; turtle procedure
  hatch-frags fragments [
    set dim 0
    rt random 360
    set size 1
    set x-vel (x-vel * .5 + dx + (random-float 2.0) - 1)
    set y-vel (y-vel * .3 + dy + (random-float 2.0) - 1)
    ifelse trails?
      [ pen-down ]
      [ pen-up ]
  ]
end

; This function changes the color of a frag.
; Each frag fades its color by an amount proportional to FADE-AMOUNT.
to fade ; frag procedure
  set dim dim - (fade-amount / 10)
  set color scale-color col dim -5 .5
  if (color < (col - 3.5)) [ die ]
end


;to go-chain
;  ask turtles
;  [ if who >= ticks [ stop ] ;; delay initial departure
;    ifelse color = red [
;    [ look-for-food ;; not carrying food? look for it
;      if distancexy coordX coordY < 5 [ ;; The movement is once again randomised after the desired positino is reached
;        set goRandom 1
;      ]
;      ifelse goRandom = 1[
;        wiggle
;      ][
;        wiggle-to-xy
;      ]
;  ]
;  ]
;end

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

In this project, a colony of ants forages for food. Though each ant follows a set of simple rules, the colony as a whole acts in a sophisticated way.

## HOW IT WORKS

When an ant finds a piece of food, it carries the food back to the nest, dropping a chemical as it moves. When other ants "sniff" the chemical, they follow the chemical toward the food. As more ants carry food to the nest, they reinforce the chemical trail.

## HOW TO USE IT

Click the SETUP button to set up the ant nest (in violet, at center) and three piles of food. Click the GO button to start the simulation. The chemical is shown in a green-to-white gradient.

The EVAPORATION-RATE slider controls the evaporation rate of the chemical. The DIFFUSION-RATE slider controls the diffusion rate of the chemical.

If you want to change the number of ants, move the POPULATION slider before pressing SETUP.

## THINGS TO NOTICE

The ant colony generally exploits the food source in order, starting with the food closest to the nest, and finishing with the food most distant from the nest. It is more difficult for the ants to form a stable trail to the more distant food, since the chemical trail has more time to evaporate and diffuse before being reinforced.

Once the colony finishes collecting the closest food, the chemical trail to that food naturally disappears, freeing up ants to help collect the other food sources. The more distant food sources require a larger "critical number" of ants to form a stable trail.

The consumption of the food is shown in a plot.  The line colors in the plot match the colors of the food piles.

## EXTENDING THE MODEL

Try different placements for the food sources. What happens if two food sources are equidistant from the nest? When that happens in the real world, ant colonies typically exploit one source then the other (not at the same time).

In this project, the ants use a "trick" to find their way back to the nest: they follow the "nest scent." Real ants use a variety of different approaches to find their way back to the nest. Try to implement some alternative strategies.

The ants only respond to chemical levels between 0.05 and 2.  The lower limit is used so the ants aren't infinitely sensitive.  Try removing the upper limit.  What happens?  Why?

In the `uphill-chemical` procedure, the ant "follows the gradient" of the chemical. That is, it "sniffs" in three directions, then turns in the direction where the chemical is strongest. You might want to try variants of the `uphill-chemical` procedure, changing the number and placement of "ant sniffs."

## NETLOGO FEATURES

The built-in `diffuse` primitive lets us diffuse the chemical easily without complicated code.

The primitive `patch-right-and-ahead` is used to make the ants smell in different directions without actually turning.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (1997).  NetLogo Ants model.  http://ccl.northwestern.edu/netlogo/models/Ants.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 1997 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the project: CONNECTED MATHEMATICS: MAKING SENSE OF COMPLEX PHENOMENA THROUGH BUILDING OBJECT-BASED PARALLEL MODELS (OBPML).  The project gratefully acknowledges the support of the National Science Foundation (Applications of Advanced Technologies Program) -- grant numbers RED #9552950 and REC #9632612.

This model was developed at the MIT Media Lab using CM StarLogo.  See Resnick, M. (1994) "Turtles, Termites and Traffic Jams: Explorations in Massively Parallel Microworlds."  Cambridge, MA: MIT Press.  Adapted to StarLogoT, 1997, as part of the Connected Mathematics Project.

This model was converted to NetLogo as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227. Converted from StarLogoT to NetLogo, 1998.

<!-- 1997 1998 MIT -->
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

poweredupant
true
0
Circle -6459832 true false 116 26 67
Circle -6459832 true false 120 90 60
Polygon -6459832 true false 120 120 180 120 150 180 120 120 165 120
Polygon -6459832 true false 150 255 105 210 195 210 150 255 150 150 195 210 105 210 150 150
Polygon -6459832 true false 150 60 105 15 105 0 105 0 90 0 90 0 150 75 105 15
Polygon -6459832 true false 135 90 90 90 75 60 75 45 60 30 90 105 150 90
Line -16777216 false 120 195 180 195
Line -16777216 false 135 180 165 180
Line -16777216 false 105 210 195 210
Line -16777216 false 120 225 180 225
Polygon -6459832 true false 150 15 135 30 135 30 165 30 150 15
Line -16777216 false 150 15 150 30
Line -16777216 false 135 45 135 45
Line -16777216 false 165 45 165 45
Polygon -6459832 true false 150 60 195 15 195 0 195 0 210 0 210 0 150 75 195 15
Polygon -6459832 true false 165 120 225 120 255 90 240 120 225 135 165 120
Polygon -6459832 true false 135 120 75 120 45 90 60 120 75 135 135 120
Polygon -6459832 true false 150 120 225 165 240 225 270 210 240 240 210 165 150 120
Polygon -6459832 true false 150 120 75 165 60 225 30 210 60 240 90 165 150 120
Polygon -6459832 true false 165 90 210 90 225 60 225 45 240 30 210 105 150 90

poweredupantv1
true
0
Circle -6459832 true false 116 26 67
Circle -6459832 true false 120 90 60
Polygon -6459832 true false 120 120 180 120 150 180 120 120 165 120
Polygon -6459832 true false 150 255 105 210 195 210 150 255 150 150 195 210 105 210 150 150
Polygon -6459832 true false 150 60 195 15 195 0 195 0 210 0 210 0 150 75 195 15
Line -16777216 false 120 195 180 195
Line -16777216 false 135 180 165 180
Line -16777216 false 105 210 195 210
Line -16777216 false 120 225 180 225
Polygon -6459832 true false 150 15 135 30 135 30 165 30 150 15
Line -16777216 false 150 15 150 30
Line -16777216 false 135 45 135 45
Line -16777216 false 165 45 165 45
Polygon -6459832 true false 150 60 90 30 75 30 105 0 75 30 75 15 150 75 120 45
Polygon -6459832 true false 165 120 225 135 255 150 240 135 225 120 165 120
Polygon -6459832 true false 135 120 90 105 60 75 75 105 90 120 135 120
Polygon -6459832 true false 150 120 210 210 210 255 240 240 210 285 195 210 150 120
Polygon -6459832 true false 150 135 60 150 30 195 0 165 30 210 60 165 150 135
Polygon -6459832 true false 165 90 210 60 225 30 225 15 240 15 210 75 150 90
Polygon -6459832 true false 135 90 90 90 60 60 60 45 30 30 90 105 150 90

poweredupantv2
true
0
Circle -6459832 true false 116 26 67
Circle -6459832 true false 120 90 60
Polygon -6459832 true false 120 120 180 120 150 180 120 120 165 120
Polygon -6459832 true false 150 255 105 210 195 210 150 255 150 150 195 210 105 210 150 150
Polygon -6459832 true false 150 60 105 15 105 0 105 0 90 0 90 0 150 75 105 15
Line -16777216 false 120 195 180 195
Line -16777216 false 135 180 165 180
Line -16777216 false 105 210 195 210
Line -16777216 false 120 225 180 225
Polygon -6459832 true false 150 15 135 30 135 30 165 30 150 15
Line -16777216 false 150 15 150 30
Line -16777216 false 135 45 135 45
Line -16777216 false 165 45 165 45
Polygon -6459832 true false 150 60 210 30 225 30 195 0 225 30 225 15 150 75 180 45
Polygon -6459832 true false 135 120 75 135 45 150 60 135 75 120 135 120
Polygon -6459832 true false 165 120 210 105 240 75 225 105 210 120 165 120
Polygon -6459832 true false 150 120 90 210 90 255 60 240 90 285 105 210 150 120
Polygon -6459832 true false 150 135 240 150 270 195 300 165 270 210 240 165 150 135
Polygon -6459832 true false 135 90 90 60 75 30 75 15 60 15 90 75 150 90
Polygon -6459832 true false 165 90 210 90 240 60 240 45 270 30 210 105 150 90

poweredupantv3
true
0
Circle -6459832 true false 116 26 67
Circle -6459832 true false 120 90 60
Polygon -6459832 true false 120 120 180 120 150 180 120 120 165 120
Polygon -6459832 true false 150 255 105 210 195 210 150 255 150 150 195 210 105 210 150 150
Polygon -6459832 true false 150 60 195 15 195 0 195 0 210 0 210 0 150 75 195 15
Line -16777216 false 120 195 180 195
Line -16777216 false 135 180 165 180
Line -16777216 false 105 210 195 210
Line -16777216 false 120 225 180 225
Polygon -6459832 true false 150 15 135 30 135 30 165 30 150 15
Line -16777216 false 150 15 150 30
Line -16777216 false 135 45 135 45
Line -16777216 false 165 45 165 45
Polygon -6459832 true false 150 60 90 30 75 30 105 0 75 30 75 15 150 75 120 45
Polygon -6459832 true false 165 120 225 135 255 150 240 135 225 120 165 120
Polygon -6459832 true false 135 120 90 105 60 75 75 105 90 120 135 120
Polygon -6459832 true false 150 120 210 210 210 255 240 240 210 285 195 210 150 120
Polygon -6459832 true false 150 135 60 150 30 195 0 165 30 210 60 165 150 135
Polygon -6459832 true false 165 90 210 60 225 30 225 15 240 15 210 75 150 90
Polygon -6459832 true false 135 90 90 60 75 30 75 15 60 15 90 75 150 90

poweredupantv4
true
0
Circle -6459832 true false 116 26 67
Circle -6459832 true false 120 90 60
Polygon -6459832 true false 120 120 180 120 150 180 120 120 165 120
Polygon -6459832 true false 150 255 105 210 195 210 150 255 150 150 195 210 105 210 150 150
Polygon -6459832 true false 150 60 195 15 195 0 195 0 210 0 210 0 150 75 195 15
Line -16777216 false 120 195 180 195
Line -16777216 false 135 180 165 180
Line -16777216 false 105 210 195 210
Line -16777216 false 120 225 180 225
Polygon -6459832 true false 150 15 135 30 135 30 165 30 150 15
Line -16777216 false 150 15 150 30
Line -16777216 false 135 45 135 45
Line -16777216 false 165 45 165 45
Polygon -6459832 true false 150 60 90 30 75 30 105 0 75 30 75 15 150 75 120 45
Polygon -6459832 true false 165 120 210 105 240 75 225 105 210 120 165 120
Polygon -6459832 true false 150 120 210 210 210 255 240 240 210 285 195 210 150 120
Polygon -6459832 true false 150 135 60 150 30 195 0 165 30 210 60 165 150 135
Polygon -6459832 true false 165 90 210 60 225 30 225 15 240 15 210 75 150 90
Polygon -6459832 true false 135 90 90 60 75 30 75 15 60 15 90 75 150 90
Polygon -6459832 true false 135 120 90 105 60 75 75 105 90 120 135 120

poweredupantv5
true
0
Circle -6459832 true false 116 26 67
Circle -6459832 true false 120 90 60
Polygon -6459832 true false 120 120 180 120 150 180 120 120 165 120
Polygon -6459832 true false 150 255 105 210 195 210 150 255 150 150 195 210 105 210 150 150
Polygon -6459832 true false 150 60 105 15 105 0 105 0 90 0 90 0 150 75 105 15
Line -16777216 false 120 195 180 195
Line -16777216 false 135 180 165 180
Line -16777216 false 105 210 195 210
Line -16777216 false 120 225 180 225
Polygon -6459832 true false 150 15 135 30 135 30 165 30 150 15
Line -16777216 false 150 15 150 30
Line -16777216 false 135 45 135 45
Line -16777216 false 165 45 165 45
Polygon -6459832 true false 150 60 210 30 225 30 195 0 225 30 225 15 150 75 180 45
Polygon -6459832 true false 135 120 75 135 45 150 60 135 75 120 135 120
Polygon -6459832 true false 165 120 210 105 240 75 225 105 210 120 165 120
Polygon -6459832 true false 150 120 90 210 90 255 60 240 90 285 105 210 150 120
Polygon -6459832 true false 150 135 240 150 270 195 300 165 270 210 240 165 150 135
Polygon -6459832 true false 135 90 90 90 60 60 60 45 30 30 90 105 150 90
Polygon -6459832 true false 165 90 210 90 240 60 240 45 270 30 210 105 150 90

poweredupantv6
true
0
Circle -6459832 true false 116 26 67
Circle -6459832 true false 120 90 60
Polygon -6459832 true false 120 120 180 120 150 180 120 120 165 120
Polygon -6459832 true false 150 255 105 210 195 210 150 255 150 150 195 210 105 210 150 150
Polygon -6459832 true false 150 60 105 15 105 0 105 0 90 0 90 0 150 75 105 15
Line -16777216 false 120 195 180 195
Line -16777216 false 135 180 165 180
Line -16777216 false 105 210 195 210
Line -16777216 false 120 225 180 225
Polygon -6459832 true false 150 15 135 30 135 30 165 30 150 15
Line -16777216 false 150 15 150 30
Line -16777216 false 135 45 135 45
Line -16777216 false 165 45 165 45
Polygon -6459832 true false 150 60 210 30 225 30 195 0 225 30 225 15 150 75 180 45
Polygon -6459832 true false 165 120 225 135 255 150 240 135 225 120 165 120
Polygon -6459832 true false 150 120 90 210 90 255 60 240 90 285 105 210 150 120
Polygon -6459832 true false 150 135 240 150 270 195 300 165 270 210 240 165 150 135
Polygon -6459832 true false 135 90 90 90 60 60 60 45 30 30 90 105 150 90
Polygon -6459832 true false 165 90 210 90 240 60 240 45 270 30 210 105 150 90
Polygon -6459832 true false 135 120 75 135 45 150 60 135 75 120 135 120

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
