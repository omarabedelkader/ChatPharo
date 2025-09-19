Class {
	#name : 'ChatPharoSecurityTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'tests' }
ChatPharoSecurityTest >> testHistoryMessageChatMessagesOnOmitsNilContentKey [

        | message entries |
        message := ChatPharoHistoryMessage role: 'assistant' content: nil.
        entries := Array streamContents: [ :stream |
                message chatMessagesOn: stream ].

        self deny: ((entries first) includesKey: 'content')
]

{ #category : 'tests' }
ChatPharoSecurityTest >> testHistorySaverPutOpenAIChatMessagesOnWithNilContentUsesPlaceholders [

        | call saver entries |
        call := ChatPharoHistorySaverToolCall
                id: 'tool'
                functionName: 'fn'
                arguments: nil
                content: nil.
        saver := ChatPharoHistorySaver
                role: 'assistant'
                content: nil
                toolCalls: { call }.
        entries := Array streamContents: [ :stream |
                saver putOpenAIChatMessagesOn: stream ].

        self assert: (entries first at: 'content') equals: '[No assistant response]'.
        self assert: (entries second at: 'content') equals: '[No tool result]'
]

{ #category : 'tests' }
ChatPharoSecurityTest >> testHistorySaverToolCallOpenAIChatToolCallIncludesFunctionType [

        | call dict |
        call := ChatPharoHistorySaverToolCall
                id: 'tool'
                functionName: 'run'
                arguments: '{}'
                content: 'ok'.
        dict := call openAIChatToolCall.

        self assert: (dict at: 'type') equals: 'function'.
        self assert: (dict at: 'id') equals: 'tool'
]

{ #category : 'tests' }
ChatPharoSecurityTest >> testHistorySaverToolCallWithNilArgumentsProducesEmptyJsonString [

        | call dict |
        call := ChatPharoHistorySaverToolCall
                id: '1'
                functionName: 'fn'
                arguments: nil
                content: 'result'.
        dict := call openAIChatToolCall.

        self assert: (dict at: 'function' at: 'arguments') equals: '{}'
]

{ #category : 'tests' }
ChatPharoSecurityTest >> testLoggerAgentNameForObjectWithoutDisplayNameUsesClassName [

        | agentName |
        agentName := ChatPharoLogger agentNameFor: Object new.

        self assert: agentName equals: 'Object'
]

{ #category : 'tests' }
ChatPharoSecurityTest >> testLoggerStringifyNilReturnsNilString [

        self assert: (ChatPharoLogger stringify: nil) equals: 'nil'
]

{ #category : 'tests' }
ChatPharoSecurityTest >> testLoggingDisabledPreventsFrontendLogCreation [

        ChatPharoLogger loggingEnabled: false.
        ChatPharoLogger deleteLogFile.

        ChatPharoLogger logFrontend: 'sensitive event'.

        self deny: ChatPharoLogger logFile exists.
        ChatPharoLogger loggingEnabled: true
]

{ #category : 'tests' }
ChatPharoSecurityTest >> testSettingsDefaultAgentIsNullAgent [

        self assert: ChatPharoSettings default agent class equals: ChatPharoNullAgent
]
