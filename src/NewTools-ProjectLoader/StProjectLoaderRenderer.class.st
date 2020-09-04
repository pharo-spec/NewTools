"
I am a simple strategy to have different rendering tools to show the text. 
I exist because we don't want to have a dependency with different renderers, for example Microdown.
"
Class {
	#name : #StProjectLoaderRenderer,
	#superclass : #Object,
	#category : #'NewTools-ProjectLoader'
}

{ #category : #testing }
StProjectLoaderRenderer class >> isAbstract [ 
	
	^ self name = #StProjectLoaderRenderer
]

{ #category : #testing }
StProjectLoaderRenderer class >> newCurrent [

	^ (self subclasses sort: [ :a :b | a priority > b priority ]) first new
]

{ #category : #testing }
StProjectLoaderRenderer class >> priority [

	^ self subclassResponsibility
]

{ #category : #parsing }
StProjectLoaderRenderer >> render: aString [

	^ self subclassResponsibility 
]
