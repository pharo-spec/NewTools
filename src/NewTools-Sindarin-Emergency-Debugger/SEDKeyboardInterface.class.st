Class {
	#name : #SEDKeyboardInterface,
	#superclass : #Object,
	#category : #'NewTools-Sindarin-Emergency-Debugger'
}

{ #category : #'as yet unclassified' }
SEDKeyboardInterface >> charIsBackspace: aChar [ 
	^aChar = Character backspace
	
]

{ #category : #'as yet unclassified' }
SEDKeyboardInterface >> charIsCR: aChar [ 
	^aChar = Character cr
	
]

{ #category : #'as yet unclassified' }
SEDKeyboardInterface >> getChar [
	
]
