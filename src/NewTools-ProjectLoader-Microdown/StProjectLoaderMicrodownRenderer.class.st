"
I am a simple Microdown renderer.
I use Microdown to generate a `Text`
"
Class {
	#name : #StProjectLoaderMicrodownRenderer,
	#superclass : #StProjectLoaderRenderer,
	#category : #'NewTools-ProjectLoader-Microdown'
}

{ #category : #testing }
StProjectLoaderMicrodownRenderer class >> priority [ 

	^ 2
]

{ #category : #'ui - operations' }
StProjectLoaderMicrodownRenderer >> render: description [

	^ [ PRRichTextComposer microdownAsRichText: description ] 
		onErrorDo: [ description ]
]
