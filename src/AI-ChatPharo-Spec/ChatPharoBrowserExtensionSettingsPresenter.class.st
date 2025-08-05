"
I'm a class that activates when the user wants chatpharo to be implemented inside the System Browser
"
Class {
	#name : 'ChatPharoBrowserExtensionSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'promptInput',
		'toolsLayout'
	],
	#category : 'AI-ChatPharo-Spec-Extentions',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Extentions'
}

{ #category : 'layout' }
ChatPharoBrowserExtensionSettingsPresenter >> defaultLayout [ 

    ^ SpBoxLayout newTopToBottom
        add: (SpBoxLayout newHorizontal
                 add: 'Browser Prompt:' expand: false;
                 add: promptInput;
                 yourself)
        expand: false;
        add: toolsLayout;
        yourself
]

{ #category : 'initialization' }
ChatPharoBrowserExtensionSettingsPresenter >> initializePresenters [

	promptInput := ChatPharoBrowserSystemPromptInputPresenter on: model.
    toolsLayout := SpBoxLayout newTopToBottom.

    ChatPharoBrowserEnvironment new tools do: [ :tool |
        | cb |
        cb := self newCheckBox
                  label: tool name;
                  state: (model browserToolsEnabled includes: tool name);
                  yourself.

        cb whenChangedDo: [ :isChecked |

            isChecked
                ifTrue: [
                    model enableBrowserTool: tool name.
                ]
                ifFalse: [
                    (ChatPharoSafetyAdvisor confirmToolDisableOn: self)
                        ifTrue: [
                            model disableBrowserTool: tool name.
                        ]
                        ifFalse: [
                            UIManager default defer: [ cb state: true ] ] ]].

        toolsLayout add: cb expand: false ].
]

{ #category : 'layout' }
ChatPharoBrowserExtensionSettingsPresenter >> setModelBeforeInitialization: anObject [ 

    model := anObject
]
