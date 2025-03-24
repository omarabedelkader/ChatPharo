"
The OGemmaModel class is a subclass of OModel that represents the Gemma model in ChatPharo. 
It provides methods to create instances of different Gemma variants using Ollama.

The #name method returns 'gemma', ensuring compatibility with Ollama’s model naming.
The class methods #small and #large create instances of OGemmaModel with tag values '2b' and '7b', 
corresponding to Gemma-2B and Gemma-7B model versions.
"
Class {
	#name : 'OGemmaModel',
	#superclass : 'OModel',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'as yet unclassified' }
OGemmaModel class >> b2 [

    <ollamaInit: 'gemma:2b'>   
    ^ self new 
          tag: '2b'; 
          yourself
]

{ #category : 'as yet unclassified' }
OGemmaModel class >> b7 [

    <ollamaInit: 'gemma:7b'>   
    ^ self new 
          tag: '7b'; 
          yourself
]

{ #category : 'accessing' }
OGemmaModel >> name [
    
    ^ 'gemma'
]
