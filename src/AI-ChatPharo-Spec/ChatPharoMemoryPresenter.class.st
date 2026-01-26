"
Settings presenter for managing ChatPharo Long-Term Memory.
Allows users to:
- View all stored memories
- Delete individual memories
- Configure memory settings (retention, max items)
- Toggle memory tracking on/off
- Clear all memories
- Add new memories manually
"
Class {
	#name : 'ChatPharoMemoryPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'memoriesList',
		'memoryDetailText',
		'memoryEnabledCheckBox',
		'autoSummarizeCheckBox',
		'retentionDaysInput',
		'maxItemsInput',
		'deleteButton',
		'clearAllButton',
		'addMemoryButton',
		'refreshButton',
		'memoryTypeDropList',
		'newMemoryInput'
	],
	#category : 'AI-ChatPharo-Spec-Skills',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Skills'
}

{ #category : 'adding' }
ChatPharoMemoryPresenter >> addNewMemory [
	"Add a new memory item based on user input"

	| content type memory |
	content := newMemoryInput text trimBoth.
	content isEmpty ifTrue: [
		self inform: 'Please enter memory content.'.
		^ self ].

	type := memoryTypeDropList selectedItem.

	memory := type = 'User Preference'
		          ifTrue: [ ChatPharoMemoryItem userPreference: content ]
		          ifFalse: [
			          type = 'Correction'
				          ifTrue: [ ChatPharoMemoryItem correction: content ]
				          ifFalse: [
					          type = 'Topic Knowledge'
						          ifTrue: [
						          ChatPharoMemoryItem topicKnowledge: content topic: 'manual' ]
						          ifFalse: [ ChatPharoMemoryItem content: content ] ] ].

	ChatPharoMemory default addMemory: memory.
	newMemoryInput text: ''.
	self refreshMemoriesList.
	self inform: 'Memory added successfully.'
]

{ #category : 'adding' }
ChatPharoMemoryPresenter >> allMemories [
	"Returns all stored memories"

	^ ChatPharoMemory default allMemories reversed
]

{ #category : 'adding' }
ChatPharoMemoryPresenter >> clearAllMemories [
	"Clear all stored memories after confirmation"

	(self confirm: 'Are you sure you want to delete ALL memories? This cannot be undone.')
		ifFalse: [ ^ self ].

	ChatPharoMemory default clearAllMemories.
	self refreshMemoriesList.
	self inform: 'All memories have been cleared.'
]

{ #category : 'adding' }
ChatPharoMemoryPresenter >> connectPresenters [

	memoryEnabledCheckBox whenChangedDo: [ :state |
		model memoryEnabled: state.
		ChatPharoMemory default enabled: state ].

	autoSummarizeCheckBox whenChangedDo: [ :state |
		model memoryAutoSummarize: state.
		ChatPharoMemory default autoSummarize: state ].

	retentionDaysInput whenTextChangedDo: [ :text |
		text trimBoth ifNotEmpty: [ :t |
			| days |
			days := t asNumber.
			model memoryRetentionDays: days.
			ChatPharoMemory default retentionDays: days ] ].

	maxItemsInput whenTextChangedDo: [ :text |
		text trimBoth ifNotEmpty: [ :t |
			| max |
			max := t asNumber.
			model memoryMaxItems: max.
			ChatPharoMemory default maxMemories: max ] ].

	memoriesList whenSelectedItemChangedDo: [ :item |
		item ifNotNil: [ self updateDetailFor: item ] ].

	deleteButton action: [ self deleteSelectedMemory ].
	clearAllButton action: [ self clearAllMemories ].
	addMemoryButton action: [ self addNewMemory ].
	refreshButton action: [ self refreshMemoriesList ]
]

{ #category : 'layout' }
ChatPharoMemoryPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  borderWidth: 8;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Long-Term Memory' expand: false;
				   addLast: refreshButton expand: false;
				   yourself)
		  expand: false;
		  add: memoryEnabledCheckBox expand: false;
		  add: autoSummarizeCheckBox expand: false;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 8;
				   add: 'Retention (days):' expand: false;
				   add: retentionDaysInput width: 80;
				   add: 'Max items:' expand: false;
				   add: maxItemsInput width: 80;
				   yourself)
		  expand: false;
		  add: (SpPanedLayout newTopToBottom
				   positionOfSlider: 60 percent;
				   add: memoriesList;
				   add: memoryDetailText;
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   spacing: 8;
				   add: deleteButton expand: false;
				   add: clearAllButton expand: false;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 8;
				   add: 'Add memory:' expand: false;
				   add: memoryTypeDropList width: 120;
				   add: newMemoryInput;
				   add: addMemoryButton expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : 'adding' }
ChatPharoMemoryPresenter >> deleteSelectedMemory [
	"Delete the currently selected memory"

	| selected |
	selected := memoriesList selectedItem.
	selected ifNil: [
		self inform: 'Please select a memory to delete.'.
		^ self ].

	(self confirm:
		 'Delete this memory: "' , (selected content truncateTo: 50) , '"?')
		ifFalse: [ ^ self ].

	ChatPharoMemory default removeMemory: selected.
	self refreshMemoriesList.
	memoryDetailText text: 'Memory deleted.'
]

{ #category : 'initialization' }
ChatPharoMemoryPresenter >> initializePresenters [

	super initializePresenters.

	memoriesList := self newTable
		                addColumn:
			                (SpStringTableColumn
				                 title: 'Type'
				                 evaluated: [ :mem | mem type ]);
		                addColumn: (SpStringTableColumn
				                 title: 'Content'
				                 evaluated: [ :mem | mem content truncateTo: 60 ]);
		                addColumn: (SpStringTableColumn
				                 title: 'Age'
				                 evaluated: [ :mem |
					                 mem ageInDays < 1
						                 ifTrue: [ 'Today' ]
						                 ifFalse: [ mem ageInDays asInteger asString , 'd' ] ]);
		                addColumn: (SpStringTableColumn
				                 title: 'Importance'
				                 evaluated: [ :mem |
					                 (mem importance * 100) asInteger asString , '%' ]);
		                items: self allMemories;
		                yourself.

	memoryDetailText := self newText
		                    beNotEditable;
		                    text:
			                    'Select a memory to see its details.';
		                    yourself.

	memoryEnabledCheckBox := self newCheckBox
		                         label: 'Enable long-term memory tracking';
		                         state: model memoryEnabled;
		                         yourself.

	autoSummarizeCheckBox := self newCheckBox
		                         label:
			                         'Auto-summarize conversations to memory';
		                         state: model memoryAutoSummarize;
		                         yourself.

	retentionDaysInput := self newNumberInput
		                      placeholder: '30';
		                      text: model memoryRetentionDays asString;
		                      yourself.

	maxItemsInput := self newNumberInput
		                 placeholder: '1000';
		                 text: model memoryMaxItems asString;
		                 yourself.

	deleteButton := self newButton
		                label: 'Delete Selected';
		                icon: (self iconNamed: #delete);
		                help: 'Delete the selected memory';
		                yourself.

	clearAllButton := self newButton
		                  label: 'Clear All Memories';
		                  icon: (self iconNamed: #glamorousTrash);
		                  help: 'Delete all stored memories';
		                  yourself.

	addMemoryButton := self newButton
		                   label: 'Add';
		                   icon: (self iconNamed: #add);
		                   help: 'Add a new memory';
		                   yourself.

	refreshButton := self newButton
		                 label: 'Refresh';
		                 icon: (self iconNamed: #refresh);
		                 help: 'Refresh the memory list';
		                 yourself.

	memoryTypeDropList := self newDropList
		                      items:
			                      #( 'General' 'User Preference' 'Correction'
			                         'Topic Knowledge' );
		                      selectFirst;
		                      yourself.

	newMemoryInput := self newTextInput
		                  placeholder: 'Enter memory content...';
		                  yourself
]

{ #category : 'initialization' }
ChatPharoMemoryPresenter >> memoryCount [
	"Return the count of stored memories"

	^ ChatPharoMemory default memoryCount
]

{ #category : 'initialization' }
ChatPharoMemoryPresenter >> refreshMemoriesList [
	"Refresh the memories list from storage"

	memoriesList items: self allMemories
]

{ #category : 'accessing - model' }
ChatPharoMemoryPresenter >> setModelBeforeInitialization: aSettings [

	model := aSettings
]

{ #category : 'initialization' }
ChatPharoMemoryPresenter >> updateDetailFor: aMemory [
	"Update the detail text area with memory information"

	| text |
	text := String streamContents: [ :stream |
		        stream
			        nextPutAll: '=== Memory Details ===';
			        cr;
			        cr;
			        nextPutAll: 'ID: ';
			        nextPutAll: aMemory id;
			        cr;
			        nextPutAll: 'Type: ';
			        nextPutAll: aMemory type;
			        cr;
			        nextPutAll: 'Created: ';
			        nextPutAll: aMemory timestamp asString;
			        cr;
			        nextPutAll: 'Age: ';
			        nextPutAll: aMemory ageInDays asInteger asString;
			        nextPutAll: ' days';
			        cr;
			        nextPutAll: 'Importance: ';
			        nextPutAll: (aMemory importance * 100) asInteger asString;
			        nextPutAll: '%';
			        cr;
			        nextPutAll: 'Tags: ';
			        nextPutAll:
				        (aMemory tags isEmpty
					         ifTrue: [ '(none)' ]
					         ifFalse: [ aMemory tags joinUsing: ', ' ]);
			        cr;
			        cr;
			        nextPutAll: '--- Content ---';
			        cr;
			        nextPutAll: aMemory content;
			        cr;
			        cr;
			        nextPutAll: '--- Metadata ---';
			        cr.
		        aMemory metadata keysAndValuesDo: [ :key :value |
			        stream
				        nextPutAll: key asString;
				        nextPutAll: ': ';
				        nextPutAll: value asString;
				        cr ] ].

	memoryDetailText text: text
]
