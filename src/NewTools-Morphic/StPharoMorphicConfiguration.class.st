Class {
	#name : 'StPharoMorphicConfiguration',
	#superclass : 'SpMorphicConfiguration',
	#category : 'NewTools-Morphic',
	#package : 'NewTools-Morphic'
}

{ #category : 'defaults' }
StPharoMorphicConfiguration class >> defaultStyleSheet [

	^ SpStyle defaultStyleSheet
]

{ #category : 'configuring' }
StPharoMorphicConfiguration >> configure: anApplication [

	super configure: anApplication
]

{ #category : 'configuring' }
StPharoMorphicConfiguration >> configureOSX: anApplication [
	
	self addStyleSheet: self styleSheetOSX
]

{ #category : 'private - factory' }
StPharoMorphicConfiguration >> newStyleSheet [
	
	^ StPharoStyleContributor availableContributors 
		inject: SpStyle defaultStyleSheet 
		into: [ :accum :each | accum, (each styleSheetContribution) ]
]

{ #category : 'initialization' }
StPharoMorphicConfiguration >> reset [

	SpStyle reset.
	styleSheet := self newStyleSheet
]

{ #category : 'styling' }
StPharoMorphicConfiguration >> styleSheetOSX [
	"Just an example on how to build styles programatically ;)"

	^ SpStyle newApplication 
		addClass: 'label' with: [ :label |
			label addClass: 'shortcut' with: [ :shortcut |
				shortcut addPropertyFontWith: [ :font |
					font name: 'Lucida Grande'; size: 10 ] ] ];
		yourself
]
