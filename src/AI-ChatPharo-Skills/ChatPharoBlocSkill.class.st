"
Skill providing context about the Bloc UI framework.
Bloc is a modern, vector-based UI framework for Pharo that provides
low-level graphics primitives and a scene graph approach to building
user interfaces.
"
Class {
	#name : 'ChatPharoBlocSkill',
	#superclass : 'ChatPharoSkill',
	#category : 'AI-ChatPharo-Skills',
	#package : 'AI-ChatPharo-Skills'
}

{ #category : 'accessing' }
ChatPharoBlocSkill >> contextString [

	^ '## Bloc UI Framework Documentation
### Overview
Bloc is a low-level, vector graphics UI framework for Pharo. It provides:
- A scene graph based rendering model
- GPU-accelerated graphics via Skia
- Flexible layout system
- Rich event handling
### Core Concepts
#### BlElement (Base Building Block)
Every visual component is a BlElement. It can:
- Have children elements
- Define its own drawing
- Handle events
- Apply layouts
```smalltalk
"Create a basic element"
element := BlElement new
    size: 100@100;
    background: Color blue;
    yourself.
"Open in a space (window)"
element openInNewSpace.
```
#### Creating Custom Elements
```smalltalk
"Simple colored box"
box := BlElement new
    size: 200@100;
    background: Color red;
    border: (BlBorder paint: Color black width: 2);
    yourself.
"With corner radius"
rounded := BlElement new
    size: 100@100;
    background: Color green;
    geometry: (BlRoundedRectangleGeometry cornerRadius: 20);
    yourself.
```
#### Text Elements
```smalltalk
"Simple text"
text := BlTextElement new
    text: ''Hello Bloc'' asRopedText;
    yourself.
"Styled text"
styledText := ''Styled Text'' asRopedText
    foreground: Color blue;
    fontSize: 24;
    bold.
textElement := BlTextElement new text: styledText.
```
### Layout System
#### BlLinearLayout
```smalltalk
"Horizontal layout"
container := BlElement new
    layout: BlLinearLayout horizontal;
    constraintsDo: [ :c |
        c horizontal fitContent.
        c vertical fitContent ];
    yourself.
container addChild: (BlElement new size: 50@50; background: Color red).
container addChild: (BlElement new size: 50@50; background: Color blue).
container addChild: (BlElement new size: 50@50; background: Color green).
"Vertical layout"
container := BlElement new
    layout: BlLinearLayout vertical;
    constraintsDo: [ :c |
        c horizontal fitContent.
        c vertical fitContent ];
    yourself.
```
#### BlFrameLayout (Overlay/Stack)
```smalltalk
frame := BlElement new
    layout: BlFrameLayout new;
    size: 200@200;
    yourself.
"Children stack on top of each other"
frame addChild: (BlElement new
    size: 150@150;
    background: Color red;
    constraintsDo: [ :c | c frame horizontal alignCenter. c frame vertical alignCenter ]).
```
#### BlGridLayout
```smalltalk
grid := BlElement new
    layout: (BlGridLayout horizontal columnCount: 3);
    constraintsDo: [ :c |
        c horizontal fitContent.
        c vertical fitContent ];
    yourself.
9 timesRepeat: [
    grid addChild: (BlElement new size: 50@50; background: Color random) ].
```
### Constraints
```smalltalk
element constraintsDo: [ :c |
    "Size constraints"
    c horizontal matchParent.   "Fill parent width"
    c vertical fitContent.      "Size to content"
    c horizontal exact: 100.    "Fixed width"
    c vertical exact: 50.       "Fixed height"
    c minWidth: 50.
    c maxWidth: 200.
    "Linear layout constraints"
    c linear weight: 1.         "Flex weight"
    "Frame layout alignment"
    c frame horizontal alignLeft.
    c frame horizontal alignCenter.
    c frame horizontal alignRight.
    c frame vertical alignTop.
    c frame vertical alignCenter.
    c frame vertical alignBottom.
].
```
### Event Handling
```smalltalk
element := BlElement new
    size: 100@100;
    background: Color blue;
    yourself.
"Click handler"
element addEventHandlerOn: BlClickEvent do: [ :event |
    event target background: Color random ].
"Mouse enter/leave"
element addEventHandlerOn: BlMouseEnterEvent do: [ :event |
    event target background: Color yellow ].
element addEventHandlerOn: BlMouseLeaveEvent do: [ :event |
    event target background: Color blue ].
"Drag"
element addEventHandlerOn: BlDragStartEvent do: [ :event |
    "drag started" ].
element addEventHandlerOn: BlDragEvent do: [ :event |
    event target position: event position ].
```
### Custom Drawing
```smalltalk
"Override drawOnSparseCanvas: for custom drawing"
MyElement >> drawOnSparseCanvas: aCanvas
    aCanvas fill
        path: self boundsInLocal;
        paint: Color blue;
        draw.
    aCanvas stroke
        path: (aCanvas shape line: 0@0 to: self extent);
        paint: Color red;
        width: 2;
        draw.
```
### Animations
```smalltalk
element := BlElement new
    size: 50@50;
    background: Color blue;
    yourself.
"Animate position"
animation := BlTransformAnimation new
    transformDo: [ :t | t translateBy: 200@0 ];
    duration: 2 seconds.
element addAnimation: animation.
"Animate color"
element addAnimation: (BlColorTransition new
    from: Color blue;
    to: Color red;
    duration: 1 second;
    onStepDo: [ :color | element background: color ]).
```
### Spaces (Windows)
```smalltalk
"Create a space"
space := BlSpace new.
space root addChild: myElement.
space extent: 800@600.
space title: ''My Bloc Application''.
space show.
"Or use shortcut"
myElement openInNewSpace.
```
### Integration Patterns
```smalltalk
"Create a simple button"
BlButton >> initialize
    super initialize.
    self
        layout: BlLinearLayout horizontal alignCenter;
        padding: (BlInsets all: 10);
        background: Color lightGray;
        geometry: (BlRoundedRectangleGeometry cornerRadius: 5).
    label := BlTextElement new.
    self addChild: label.
    self addEventHandlerOn: BlClickEvent do: [ :e | self onClick ].
    self addEventHandlerOn: BlMouseEnterEvent do: [ :e |
        self background: Color gray ].
    self addEventHandlerOn: BlMouseLeaveEvent do: [ :e |
        self background: Color lightGray ].
BlButton >> label: aString
    label text: aString asRopedText.
BlButton >> onClick
    self announce: BlClickEvent new.
```
### Tips
- Use `constraintsDo:` for all sizing and positioning
- Bloc uses a pull model - call `requestLayout` after changes
- Use `BlFrameLayout` for overlapping/stacking elements
- Text uses RopedText for rich formatting
- Events bubble up through the element tree
- Use `openInNewSpace` for quick testing'
]

{ #category : 'accessing' }
ChatPharoBlocSkill >> description [ 

	^ 'Bloc low-level UI framework for building vector graphics interfaces with scene graph, layouts, and event handling.'
]

{ #category : 'accessing' }
ChatPharoBlocSkill >> keywords [

	^ #(
		'Bloc' 'BlElement' 'BlSpace' 'BlTextElement'
		'BlLinearLayout' 'BlFrameLayout' 'BlGridLayout'
		'BlClickEvent' 'BlMouseEnterEvent' 'BlMouseLeaveEvent'
		'BlBorder' 'BlBackground' 'BlGeometry'
		'BlRoundedRectangleGeometry' 'BlAnimation'
		'constraintsDo' 'matchParent' 'fitContent'
		'openInNewSpace' 'RopedText'
		'scene graph' 'vector graphics' 'GPU' 'Skia'
	)
]

{ #category : 'accessing' }
ChatPharoBlocSkill >> name [

	^ 'Bloc'
]
