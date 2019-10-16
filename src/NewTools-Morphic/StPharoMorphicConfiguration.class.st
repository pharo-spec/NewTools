Class {
	#name : #StPharoMorphicConfiguration,
	#superclass : #SpApplicationConfiguration,
	#category : #'NewTools-Morphic'
}

{ #category : #defaults }
StPharoMorphicConfiguration class >> defaultStyleSheet [

	^ SpStyle defaultStyleSheet
]

{ #category : #configuring }
StPharoMorphicConfiguration >> configure: anApplication [

	super configure: anApplication.
	anApplication styleSheet: self class defaultStyleSheet
]
