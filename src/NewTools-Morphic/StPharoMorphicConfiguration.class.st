Class {
	#name : #StPharoMorphicConfiguration,
	#superclass : #SpApplicationConfiguration,
	#category : #'NewTools-Morphic'
}

{ #category : #'as yet unclassified' }
StPharoMorphicConfiguration class >> defaultStyleSheet [

	^ SpStyle defaultStyleSheet
]

{ #category : #accessing }
StPharoMorphicConfiguration class >> styleSheetPropertyName [

	^ #styleSheet
]

{ #category : #configuring }
StPharoMorphicConfiguration >> configure: anApplication [

	super configure: anApplication.
	anApplication 
		propertyAt: self class styleSheetPropertyName
		put: self class defaultStyleSheet
]
