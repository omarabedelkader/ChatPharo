"
This a class that class chatpharo at user request inside a specific env
"
Class {
	#name : 'AIChatPharoState',
	#superclass : 'WorldState',
	#category : 'AI-ChatPharo-Env',
	#package : 'AI-ChatPharo-Env'
}

{ #category : 'world state' }
AIChatPharoState class >> aiWorldMenuOn: aBuilder [
    <worldMenu>
    (aBuilder item: #AI)
        order: 10;
        help: 'Tools to explore and modify the image';
        with: [
	
            (aBuilder item: #'ChatPharo')
                action: [ ChatPharo new presenter open ];
                help: 'Open ChatPharo'.

            (aBuilder item: #'ChatPharoSettings')
                action: [ ChatPharoSettings new presenter open ];
                help: 'Open ChatPharo settings'
        ].

]
