"
I represent a class as a ̀FinderResult̀.
"
Class {
	#name : 'StFinderTraitResult',
	#superclass : 'StFinderClassResult',
	#category : 'NewTools-Finder-Result',
	#package : 'NewTools-Finder',
	#tag : 'Result'
}

{ #category : 'testing' }
StFinderTraitResult class >> matches: aCompiledMethod [ 
	"Answer <true> if aCompiledMethod comes from a trait"
	
	^ aCompiledMethod methodClass isTrait
]

{ #category : 'accessing' }
StFinderTraitResult >> content: aCompiledMethod [

	content := aCompiledMethod traitSource
		ifNil: [ aCompiledMethod methodClass ]
		ifNotNil: [ aCompiledMethod traitSource ]

]

{ #category : 'displaying' }
StFinderTraitResult >> displayIcon [

	^ self iconNamed: #trait
]

{ #category : 'action' }
StFinderTraitResult >> forFinderPreview: aSpCodePresenter [

	^ self parent
		  ifNotNil: [ self displaySource: self getCompiledMethod in: aSpCodePresenter ]
		  ifNil: [
			  aSpCodePresenter
				  beForScripting;
				  text: self content definitionString ]
]
