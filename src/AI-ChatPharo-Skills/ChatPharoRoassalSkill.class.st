"
kill providing context about the Roassal visualization engine.
Roassal is Pharo's powerful visualization library for creating
interactive graphics, charts, and diagrams. This skill provides
documentation about:
- Canvas and shapes
- Layouts
- Events and interactions
- Charts and graphs
- Animations
"
Class {
	#name : 'ChatPharoRoassalSkill',
	#superclass : 'ChatPharoSkill',
	#category : 'AI-ChatPharo-Skills',
	#package : 'AI-ChatPharo-Skills'
}

{ #category : 'accessing' }
ChatPharoRoassalSkill >> contextString [

	^ '## Roassal Visualization Engine Documentation
### Overview
Roassal is a powerful visualization engine for Pharo. It provides:
- A canvas-based rendering system
- Rich set of shapes and layouts
- Interactive events and animations
- Charting capabilities
### Core Concepts
#### RSCanvas (The Drawing Surface)
```smalltalk
"Create a canvas"
canvas := RSCanvas new.
"Add shapes"
canvas add: (RSBox new size: 100; color: Color blue).
canvas add: (RSEllipse new size: 50; color: Color red).
"Open the canvas"
canvas open.
```
#### Basic Shapes
##### RSBox (Rectangle)
```smalltalk
RSBox new
    size: 100;
    color: Color blue;
    borderColor: Color black;
    borderWidth: 2;
    yourself.
"Or with width/height"
RSBox new
    width: 150;
    height: 80;
    color: Color green.
```
##### RSEllipse (Circle/Oval)
```smalltalk
RSEllipse new
    size: 100;  "circle"
    color: Color red.
RSEllipse new
    width: 100;
    height: 50;  "oval"
    color: Color yellow.
```
##### RSLabel (Text)
```smalltalk
RSLabel new
    text: ''Hello Roassal'';
    fontSize: 20;
    color: Color black;
    yourself.
```
##### RSLine
```smalltalk
RSLine new
    from: 0@0;
    to: 100@100;
    color: Color black;
    width: 2;
    yourself.
```
##### RSPolygon
```smalltalk
RSPolygon new
    points: { 0@0. 50@100. 100@0 };
    color: Color orange;
    yourself.
```
##### RSComposite (Group shapes)
```smalltalk
composite := RSComposite new.
composite add: (RSBox new size: 50; color: Color blue).
composite add: (RSLabel new text: ''Label'').
RSVerticalLineLayout on: composite shapes.
composite adjustToChildren.
```
### Positioning and Transformations
```smalltalk
shape := RSBox new size: 50.
"Position"
shape position: 100@200.
shape translateTo: 150@250.
shape translateBy: 10@10.
"Rotation"
shape rotateByDegrees: 45.
"Scaling"
shape scaleBy: 2.
```
### Creating Multiple Shapes from Data
```smalltalk
"Create shapes from a collection"
canvas := RSCanvas new.
data := #(10 20 30 40 50).
shapes := data collect: [ :value |
    RSBox new
        size: value * 2;
        color: Color random;
        yourself ].
canvas addAll: shapes.
"Apply a layout"
RSHorizontalLineLayout on: shapes.
canvas open.
```
### Layouts
#### RSGridLayout
```smalltalk
shapes := (1 to: 20) collect: [ :i |
    RSBox new size: 30; color: Color random ].
canvas addAll: shapes.
RSGridLayout new
    gapSize: 10;
    on: shapes.
```
#### RSHorizontalLineLayout
```smalltalk
RSHorizontalLineLayout new
    gapSize: 5;
    on: shapes.
```
#### RSVerticalLineLayout
```smalltalk
RSVerticalLineLayout new
    gapSize: 5;
    on: shapes.
```
#### RSFlowLayout
```smalltalk
RSFlowLayout new
    maxWidth: 300;
    on: shapes.
```
#### RSCircleLayout
```smalltalk
RSCircleLayout new
    radius: 100;
    on: shapes.
```
#### RSTreeLayout
```smalltalk
RSTreeLayout on: shapes.
```
#### RSForceBasedLayout
```smalltalk
RSForceBasedLayout new
    charge: -300;
    on: shapes.
```
### Edges and Connections
```smalltalk
"Create nodes"
nodes := (1 to: 5) collect: [ :i |
    RSEllipse new size: 30; model: i ].
canvas addAll: nodes.
"Create edges"
edges := {
    nodes first -> nodes second.
    nodes second -> nodes third.
    nodes third -> nodes fourth.
    nodes fourth -> nodes fifth
} collect: [ :assoc |
    RSLine new
        from: assoc key;
        to: assoc value;
        yourself ].
canvas addAll: edges.
"Layout"
RSTreeLayout on: nodes edges: edges.
```
#### RSLineBuilder (Easier edge creation)
```smalltalk
shapes := RSBox models: (1 to: 10) forEach: [ :box :model |
    box size: 20; color: Color blue ].
canvas addAll: shapes.
RSLineBuilder line
    canvas: canvas;
    shapes: shapes;
    connectFrom: [ :n | n // 2 ] to: #yourself.
RSTreeLayout on: shapes.
```
### Events and Interactions
#### Mouse Events
```smalltalk
shape := RSBox new size: 50; color: Color blue.
shape when: RSMouseClick do: [ :evt |
    Transcript show: ''Clicked!''; cr.
    evt shape color: Color random.
    evt signalUpdate ].
shape when: RSMouseEnter do: [ :evt |
    evt shape color: Color yellow.
    evt signalUpdate ].
shape when: RSMouseLeave do: [ :evt |
    evt shape color: Color blue.
    evt signalUpdate ].
```
#### Built-in Interactions
```smalltalk
"Make shape draggable"
shape @ RSDraggable.
"Show popup on hover"
shape @ RSPopup.
"Highlight on hover"
shape @ RSHighlightable red.
"Make canvas zoomable and pannable"
canvas @ RSCanvasController.
```
### Charts (RSChart)
#### Line Chart
```smalltalk
chart := RSChart new.
chart addPlot: (RSLinePlot new y: #(1 4 2 5 3 6)).
chart addDecoration: RSHorizontalTick new.
chart addDecoration: RSVerticalTick new.
chart open.
```
#### Bar Chart
```smalltalk
chart := RSChart new.
chart addPlot: (RSBarPlot new y: #(5 10 3 8 7)).
chart addDecoration: RSHorizontalTick new.
chart addDecoration: RSVerticalTick new.
chart open.
```
#### Scatter Plot
```smalltalk
chart := RSChart new.
chart addPlot: (RSScatterPlot new
    x: #(1 2 3 4 5);
    y: #(2 4 1 5 3)).
chart addDecoration: RSHorizontalTick new.
chart addDecoration: RSVerticalTick new.
chart open.
```
#### Multiple Plots
```smalltalk
chart := RSChart new.
chart addPlot: (RSLinePlot new y: #(1 4 2 5 3); color: Color blue).
chart addPlot: (RSLinePlot new y: #(2 3 5 4 6); color: Color red).
chart addDecoration: RSHorizontalTick new.
chart addDecoration: RSVerticalTick new.
chart addDecoration: RSChartTitleDecoration new title: ''Comparison''.
chart addDecoration: RSXLabelDecoration new title: ''X Axis''.
chart addDecoration: RSYLabelDecoration new title: ''Y Axis''.
chart open.
```
### Animations
```smalltalk
canvas := RSCanvas new.
shape := RSBox new size: 50; color: Color blue.
canvas add: shape.
"Animate position"
canvas newAnimation
    duration: 2 seconds;
    from: 0@0;
    to: 200@200;
    on: shape set: #position:.
"Animate color"
canvas newAnimation
    duration: 1 second;
    from: Color blue;
    to: Color red;
    on: shape set: #color:.
canvas open.
```
### Integration with Spec2
```smalltalk
"Embed Roassal in a Spec2 presenter"
SpPresenter << #MyVisualizationPresenter
    slots: { #roassalPresenter };
    package: ''MyPackage''
MyVisualizationPresenter >> initializePresenters
    roassalPresenter := self instantiate: SpRoassalPresenter.
    roassalPresenter canvas: self createCanvas.
MyVisualizationPresenter >> createCanvas
    | canvas shapes |
    canvas := RSCanvas new.
    shapes := (1 to: 10) collect: [ :i |
        RSBox new size: 30; color: Color random ].
    canvas addAll: shapes.
    RSGridLayout on: shapes.
    canvas @ RSCanvasController.
    ^ canvas
MyVisualizationPresenter >> defaultLayout
    ^ SpBoxLayout newTopToBottom
        add: roassalPresenter;
        yourself'
]

{ #category : 'accessing' }
ChatPharoRoassalSkill >> description [

	^ 'Roassal visualization engine for creating interactive graphics, charts, diagrams, and data visualizations in Pharo.'
]

{ #category : 'accessing' }
ChatPharoRoassalSkill >> keywords [

	^ #(
		'Roassal' 'RSCanvas' 'RSShape' 'RSBox' 'RSEllipse' 'RSLabel' 'RSLine'
		'RSPolygon' 'RSComposite' 'RSGroup'
		'RSGridLayout' 'RSTreeLayout' 'RSForceBasedLayout' 'RSCircleLayout'
		'RSHorizontalLineLayout' 'RSVerticalLineLayout' 'RSFlowLayout'
		'RSChart' 'RSLinePlot' 'RSBarPlot' 'RSScatterPlot'
		'RSLineBuilder' 'RSEdgeBuilder'
		'RSDraggable' 'RSPopup' 'RSHighlightable' 'RSCanvasController'
		'RSMouseClick' 'RSMouseEnter' 'RSMouseLeave'
		'visualization' 'chart' 'graph' 'diagram' 'plot' 'canvas'
		'animation' 'layout' 'shape' 'edge' 'node'
		'bar chart' 'line chart' 'scatter plot' 'pie chart'
	)
]

{ #category : 'accessing' }
ChatPharoRoassalSkill >> name [

	^ 'Roassal'
]
