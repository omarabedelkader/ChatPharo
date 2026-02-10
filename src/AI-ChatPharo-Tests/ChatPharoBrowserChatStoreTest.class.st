Class {
	#name : 'ChatPharoBrowserChatStoreTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Env',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Env'
}

{ #category : 'running' }
ChatPharoBrowserChatStoreTest >> tearDown [

	"Clean up any stored histories from tests"
	ChatPharoBrowserChatStore removeHistoryForKey: 'test-key-1'.
	ChatPharoBrowserChatStore removeHistoryForKey: 'test-key-2'.
	ChatPharoBrowserChatStore removeHistoryForKey: 'nonexistent-key'.
	super tearDown
]

{ #category : 'running' }
ChatPharoBrowserChatStoreTest >> testHistoriesReturnsDict [

	self assert: ChatPharoBrowserChatStore histories isDictionary
]

{ #category : 'running' }
ChatPharoBrowserChatStoreTest >> testHistoryAtReturnsNilForMissingKey [

	self assert: (ChatPharoBrowserChatStore historyAt: 'nonexistent-key') isNil
]

{ #category : 'running' }
ChatPharoBrowserChatStoreTest >> testLoadChatForAbsentKeyReturnsFalse [

	| chat |
	chat := ChatPharoChat new.
	self deny: (ChatPharoBrowserChatStore loadChatForKey: 'absent-key' into: chat)
]

{ #category : 'running' }
ChatPharoBrowserChatStoreTest >> testLoadChatForNilKeyReturnsFalse [

	| chat |
	chat := ChatPharoChat new.
	self deny: (ChatPharoBrowserChatStore loadChatForKey: nil into: chat)
]

{ #category : 'running' }
ChatPharoBrowserChatStoreTest >> testRemoveHistoryForAbsentKey [

	"Should not fail for absent key"
	ChatPharoBrowserChatStore removeHistoryForKey: 'absent-key-9999'
]

{ #category : 'running' }
ChatPharoBrowserChatStoreTest >> testRemoveHistoryForNilKey [

	"Should not fail for nil key"
	ChatPharoBrowserChatStore removeHistoryForKey: nil
]

{ #category : 'running' }
ChatPharoBrowserChatStoreTest >> testStoreChatForNilKeyDoesNotFail [

	"Should silently return for nil key"
	| chat |
	chat := ChatPharoChat new.
	ChatPharoBrowserChatStore storeChat: chat forKey: nil
]
