Class {
	#name : 'ChatPharoIceTipCommentPanel',
	#superclass : 'IceTipCommentPanel',
	#category : 'AI-ChatPharo-Icerberg',
	#package : 'AI-ChatPharo-Icerberg'
}

{ #category : 'as yet unclassified' }
ChatPharoIceTipCommentPanel >> appendResultText: message [

	commentText text: commentText text , message
]

{ #category : 'as yet unclassified' }
ChatPharoIceTipCommentPanel >> buildPrompt [
	"Build a prompt string by iterating through the working copy diff tree roots and their children."

	^ String streamContents: [ :stream |
		self repositoryModel workingCopyDiff treeRoots do: [ :root |
			root allChildrenDo: [ :child |
				stream
					<< 'On: ';
					<< child key;
					<< String lf.
				child value printOnLLMQuery: stream.
				stream
					<< String lf;
					<< '---';
					<< String lf ] ] ]
]

{ #category : 'as yet unclassified' }
ChatPharoIceTipCommentPanel >> commitMessageSystemPrompt [

	^ 'You are a Pharo developer. Write a concise commit message based on the diff. Use imperative mood and follow Pharo/Iceberg conventions. Return only the commit message.'
]

{ #category : 'as yet unclassified' }
ChatPharoIceTipCommentPanel >> generateCommitMessage [
	"Generates a commit message using the configured ChatPharo agent and displays it in the commentText."

	| prompt agent chat |
	prompt := self buildPrompt.
	agent := ChatPharoSettings default agent.
	agent := (agent isKindOf: ChatPharoAgent)
				 ifTrue: [ agent copyForChat ]
				 ifFalse: [ agent ].
	(agent respondsTo: #systemPrompt:) ifTrue: [
		agent systemPrompt: self commitMessageSystemPrompt ].
	chat := ChatPharoChat new
				 agent: agent;
				 yourself.
	chat whenAnswerReceivedDo: [ :message | self appendResultText: message answer ].
	chat sendMessage: prompt
]

{ #category : 'as yet unclassified' }
ChatPharoIceTipCommentPanel >> initializePresenters [

	super initializePresenters.
	optionsButton add: (self newToolbarButton
			 icon: (self application iconNamed: #smallLeftFlush);
			 label: 'Generate commit message';
			 help: 'Generate the commit message based on the work';
			 action: [ self generateCommitMessage ];
			 yourself)
]
