"
Skill providing context about the Spec2 UI framework.
Spec2 is Pharo's standard UI framework for building desktop applications.
This skill provides documentation about:
- SpPresenter and its subclasses
- Layout system (SpBoxLayout, SpGridLayout, etc.)
- Common widgets (buttons, text inputs, lists, trees)
- Event handling and data binding
- Window management
"
Class {
	#name : 'ChatPharoSpec2Skill',
	#superclass : 'ChatPharoSkill',
	#category : 'AI-ChatPharo-Skills',
	#package : 'AI-ChatPharo-Skills'
}

{ #category : 'accessing' }
ChatPharoSpec2Skill >> contextString [

	^ '## Spec2 UI Framework Documentation
### Overview
Spec2 is Pharo''s standard framework for building desktop user interfaces.
It follows the Model-View-Presenter (MVP) pattern.
### Core Concepts
#### SpPresenter (Base Class)
All UI components inherit from SpPresenter. Key methods:
- `initializePresenters` - Create and configure sub-presenters
- `connectPresenters` - Set up event handlers and connections
- `defaultLayout` - Define the layout structure
- `setModelBeforeInitialization:` - Receive model before initialization
#### Creating a Basic Presenter
```smalltalk
SpPresenter << #MyPresenter
    slots: { #button . #textInput . #label };
    package: ''MyPackage''
MyPresenter >> initializePresenters
    button := self newButton
        label: ''Click me'';
        yourself.
    textInput := self newTextInput
        placeholder: ''Enter text...'';
        yourself.
    label := self newLabel
        label: ''Status'';
        yourself.
MyPresenter >> connectPresenters
    button action: [ self onButtonClicked ].
    textInput whenTextChangedDo: [ :text | self onTextChanged: text ].
MyPresenter >> defaultLayout
    ^ SpBoxLayout newTopToBottom
        spacing: 5;
        add: label expand: false;
        add: textInput expand: false;
        add: button expand: false;
        yourself
```
### Layout System
#### SpBoxLayout (Vertical/Horizontal)
```smalltalk
"Vertical layout"
SpBoxLayout newTopToBottom
    spacing: 10;
    add: presenter1;
    add: presenter2 expand: false;
    add: presenter3 height: 50;
    yourself.
"Horizontal layout"
SpBoxLayout newLeftToRight
    spacing: 5;
    add: presenter1 width: 100;
    add: presenter2;
    yourself.
```
#### SpGridLayout (Grid)
```smalltalk
SpGridLayout new
    add: ''Label:'' at: 1@1;
    add: textInput at: 2@1;
    add: button at: 1@2 span: 2@1;
    yourself.
```
#### SpPanedLayout (Resizable Panes)
```smalltalk
SpPanedLayout newLeftToRight
    positionOfSlider: 30 percent;
    add: leftPresenter;
    add: rightPresenter;
    yourself.
```
### Common Widgets
#### Buttons
```smalltalk
self newButton
    label: ''Save'';
    icon: (self iconNamed: #smallSave);
    help: ''Save the document'';
    action: [ self save ];
    yourself.
```
#### Text Input
```smalltalk
self newTextInput
    placeholder: ''Enter name...'';
    text: ''Initial value'';
    whenTextChangedDo: [ :text | "handle change" ];
    yourself.
"Multi-line text"
self newText
    text: ''Multiple lines here'';
    yourself.
```
#### Labels
```smalltalk
self newLabel
    label: ''Static text'';
    yourself.
```
#### Checkboxes
```smalltalk
self newCheckBox
    label: ''Enable feature'';
    state: true;
    whenChangedDo: [ :state | "handle change" ];
    yourself.
```
#### Drop-down Lists
```smalltalk
self newDropList
    items: #(''Option1'' ''Option2'' ''Option3'');
    display: [ :item | item asString ];
    selectItem: ''Option1'';
    whenSelectedItemChangedDo: [ :item | "handle selection" ];
    yourself.
```
#### Lists
```smalltalk
self newList
    items: myCollection;
    display: [ :item | item name ];
    whenSelectedItemChangedDo: [ :item | "handle selection" ];
    yourself.
```
#### Tables
```smalltalk
self newTable
    addColumn: (SpStringTableColumn title: ''Name'' evaluated: #name);
    addColumn: (SpStringTableColumn title: ''Age'' evaluated: #age);
    items: people;
    yourself.
```
#### Trees
```smalltalk
self newTree
    roots: rootItems;
    children: [ :item | item children ];
    display: [ :item | item name ];
    yourself.
```
#### Notebooks (Tabs)
```smalltalk
self newNotebook
    addPage: (SpNotebookPage
        title: ''Tab 1''
        icon: (self iconNamed: #smallWindow)
        provider: [ self createTab1Presenter ]);
    addPage: (SpNotebookPage
        title: ''Tab 2''
        provider: [ self createTab2Presenter ]);
    yourself.
```
### Window Management
#### Opening a Window
```smalltalk
"Open with default size"
MyPresenter new open.
"Open with custom title and size"
MyPresenter new
    open;
    withWindowDo: [ :w |
        w
            title: ''My Application'';
            initialExtent: 800@600 ].
"Or override initializeWindow:"
MyPresenter >> initializeWindow: aWindowPresenter
    super initializeWindow: aWindowPresenter.
    aWindowPresenter
        title: ''My Application'';
        initialExtent: 800@600.
```
#### Modal Dialogs
```smalltalk
"Simple confirm dialog"
self confirm: ''Are you sure?''.
"Simple inform dialog"
self inform: ''Operation completed!''.
"Custom modal"
myDialog openModal.
```
### Data Binding
#### Model Pattern
```smalltalk
"Create presenter with model"
MyPresenter on: myModelObject.
"In presenter, receive model"
MyPresenter >> setModelBeforeInitialization: aModel
    model := aModel.
"Update UI when model changes"
MyPresenter >> modelChanged
    nameInput text: model name.
    ageInput text: model age asString.
```
### Toolbar
```smalltalk
MyPresenter >> initializePresenters
    toolbar := self newToolbar
        add: (self newToolbarButton
            label: ''New'';
            icon: (self iconNamed: #smallNew);
            action: [ self newDocument ]);
        add: (self newToolbarButton
            label: ''Save'';
            icon: (self iconNamed: #smallSave);
            action: [ self save ]);
        addItem: SpToolbarSeparator new;
        yourself.
MyPresenter >> defaultLayout
    ^ SpBoxLayout newTopToBottom
        add: toolbar expand: false;
        add: mainContent;
        yourself.
```
### Menu Bar
```smalltalk
MyPresenter >> initializeMenuBar
    ^ self newMenuBar
        addGroup: [ :group |
            group
                addItem: [ :item |
                    item
                        name: ''File'';
                        subMenu: self fileMenu ] ];
        yourself.
MyPresenter >> fileMenu
    ^ self newMenu
        addItem: [ :item |
            item
                name: ''New'';
                shortcut: $n meta;
                action: [ self newDocument ] ];
        addItem: [ :item |
            item
                name: ''Save'';
                shortcut: $s meta;
                action: [ self save ] ];
        yourself.
```
### Styling
```smalltalk
"Add CSS-like styles"
button addStyle: ''primary''.
label addStyle: ''header''.
"Custom application styles defined in application class"
MyApplication >> styleSheet
    ^ SpStyle defaultStyleSheet ,
        (SpStyleSTONReader fromString: ''
            .primary [
                Container { #borderColor: #blue }
                Draw { #backgroundColor: #lightBlue }
            ]
        '')
```
### Tips
- Always create presenters in `initializePresenters`
- Connect event handlers in `connectPresenters`
- Use `expand: false` for fixed-size elements
- Use `yourself` at end of cascade for clean returns
- Override `initializeWindow:` for window configuration'
]

{ #category : 'accessing' }
ChatPharoSpec2Skill >> description [ 

	^ 'Spec2 UI framework for building desktop applications in Pharo. Covers presenters, layouts, widgets, event handling, and window management.'
]

{ #category : 'accessing' }
ChatPharoSpec2Skill >> keywords [

	^ #(
		'Spec2' 'Spec' 'SpPresenter' 'SpApplication'
		'SpBoxLayout' 'SpGridLayout' 'SpPanedLayout'
		'SpButton' 'SpTextInput' 'SpLabel' 'SpCheckBox'
		'SpDropList' 'SpList' 'SpTable' 'SpTree'
		'SpNotebook' 'SpNotebookPage' 'SpToolbar'
		'SpMenu' 'SpMenuBar' 'SpMenuItem'
		'initializePresenters' 'connectPresenters' 'defaultLayout'
		'newButton' 'newTextInput' 'newLabel' 'newCheckBox'
		'newDropList' 'newList' 'newTable' 'newTree'
		'newNotebook' 'newToolbar' 'newMenu'
		'whenSelectedItemChangedDo' 'whenTextChangedDo'
		'UI' 'GUI' 'presenter' 'widget' 'layout' 'window' 'dialog'
		'button' 'checkbox' 'dropdown' 'list' 'table' 'tree' 'tab' 'toolbar'
	)
]

{ #category : 'accessing' }
ChatPharoSpec2Skill >> name [

	^ 'Spec2'
]
