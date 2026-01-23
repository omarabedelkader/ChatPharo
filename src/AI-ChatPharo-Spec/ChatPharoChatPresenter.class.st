"
UI for one chat tab: scrollable message column, a text field, and buttons for submit/cancel/clear. Receives push updates when the model posts a new assistant message.
"
Class {
	#name : 'ChatPharoChatPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'messagesLayout',
		'messageTextField',
		'submitButton',
		'cancelButton',
		'model',
		'inspectButton',
		'scrollableMessages',
		'thinkingPresenter'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'initialization' }
ChatPharoChatPresenter >> connectPresenters [

	model messages do: [ :each |
		messagesLayout add: each presenter withConstraints: [ :constraints | constraints height: each height * 2 ] ].

	messageTextField whenSubmitDo: [ :text | self sendMessage ].

	submitButton action: [ self sendMessage ].

	cancelButton action: [
			ChatPharoLogger logFrontend: 'Cancel button pressed in chat tab' details: (Dictionary new
					 at: 'chatId' put: model identityHash;
					 yourself).
			model cancelMessage.
			self hideThinking.
			messageTextField text: ''.
			submitButton enabled: true.
			messageTextField enabled: true ].


	inspectButton action: [
			ChatPharoLogger logFrontend: 'Inspect chat requested' details: (Dictionary new
					 at: 'chatId' put: model identityHash;
					 yourself).
			model inspect ].

	model whenAnswerReceivedDo: [ :message |
			self hideThinking.
			messagesLayout add: message presenter withConstraints: [ :constraints | constraints height: message height * 2 ].
			messageTextField text: ''.
			submitButton enabled: true.
			messageTextField enabled: true.
			ChatPharoLogger logFrontend: 'Assistant message rendered' details: (Dictionary new
					 at: 'chatId' put: model identityHash;
					 at: 'assistantLabel' put: message assistantLabel;
					 yourself) ].


	model whenToolExecutionDo: [
			thinkingPresenter phase: #executing.
			ChatPharoLogger logFrontend: 'Tool execution feedback shown'
                                details: (Dictionary new
                                        at: 'chatId' put: model identityHash;
                                        yourself) ]
]

{ #category : 'layout' }
ChatPharoChatPresenter >> defaultLayout [
    ^ SpBoxLayout newVertical
          spacing: 10;
          add: (SpScrollableLayout with: scrollableMessages);
          add: (SpBoxLayout newHorizontal
                   spacing: 5;
                   add: messageTextField;
                   add: submitButton expand: false;
                   add: cancelButton expand: false;
						 add: inspectButton expand: false;
                   yourself)
          expand: false;
          yourself
]

{ #category : 'accessing' }
ChatPharoChatPresenter >> exportAsJson [

    | msgs |
    msgs :=  model historyMessages collect: [ :msg |
        | dict |
        dict := Dictionary new
            at: 'role' put: msg role;
            at: 'content' put: (msg content ifNil: [ '' ]);
            yourself.
        msg toolCalls ifNotNil: [
            dict at: 'tool_calls' put:
                (msg toolCalls collect: [ :tc |
                    (tc respondsTo: #openAIChatToolCall)
                        ifTrue: [ tc openAIChatToolCall ]
                        ifFalse: [ tc ] ] as: Array)
        ].
        dict ].
    ^ STONJSON toString: (msgs as: Array)
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> hideThinking [
	"Hide the thinking indicator and stop animation"

	thinkingPresenter stopAnimation.
	messagesLayout remove: thinkingPresenter ifAbsent: [ "not shown" ]
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> initializePresenters [

	messageTextField := self newTextInput
		                    placeholder: 'Type your message here...';
		                    yourself.

	submitButton := self newButton
		                label: 'Submit';
		                icon: (self iconNamed: #glamorousGo);
		                help: 'Submit prompt';
		                yourself.

	cancelButton := self newButton
		                label: 'Cancel';
		                icon: (self iconNamed: #delete);
		                help: 'Cancel prompt';
		                yourself.

	inspectButton := self newButton
		                 label: 'Inspect';
		                 icon: (self iconNamed: #inspect);
		                 help: 'Inspect the chat object';
		                 yourself.

	thinkingPresenter := self instantiate: ChatPharoThinkingPresenter.

	messagesLayout := SpBoxLayout newVertical.
	scrollableMessages := SpPresenter new.
	scrollableMessages layout: messagesLayout
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'Pharo chat';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> sendMessage [

	| text |
	text := messageTextField text.
	model agent isConfigured ifFalse: [
			ChatPharoLogger logFrontend: 'Send blocked - agent not configured' details: (Dictionary new
					 at: 'chatId' put: model identityHash;
					 at: 'agent' put: (ChatPharoLogger agentNameFor: model agent);
					 yourself).
			self inform: model agent configurationErrorMessage.
			^ self ].
	ChatPharoLogger logFrontend: 'Chat tab send triggered' details: (Dictionary new
			 at: 'chatId' put: model identityHash;
			 at: 'text' put: text;
			 at: 'agent' put: (ChatPharoLogger agentNameFor: model agent);
			 yourself).
	submitButton enabled: false.
	messageTextField enabled: false.
	messageTextField text: ''.
	self showThinking.
	model sendMessage: text
]

{ #category : 'accessing - model' }
ChatPharoChatPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> showThinking [
	"Show the thinking indicator with animation"

	thinkingPresenter phase: #thinking.
	thinkingPresenter startAnimation.
	messagesLayout add: thinkingPresenter withConstraints: [ :constraints | constraints height: 40 ]
]
