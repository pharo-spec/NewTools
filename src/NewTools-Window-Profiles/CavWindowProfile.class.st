"
I'm a collection of window configuration (extent, position, kind)
"
Class {
	#name : 'CavWindowProfile',
	#superclass : 'Object',
	#instVars : [
		'profileName',
		'placeHolderDictionary',
		'cellSize'
	],
	#category : 'NewTools-Window-Profiles-Model',
	#package : 'NewTools-Window-Profiles',
	#tag : 'Model'
}

{ #category : 'adding' }
CavWindowProfile >> add: aCavroisWindowPlaceHolder [

	(placeHolderDictionary
		 at: aCavroisWindowPlaceHolder kind
		 ifPresent: [
		 placeHolderDictionary at: aCavroisWindowPlaceHolder kind ]
		 ifAbsent: [
			 | col |
			 col := OrderedCollection new.
			 placeHolderDictionary at: aCavroisWindowPlaceHolder kind put: col.
			 col ]) add: aCavroisWindowPlaceHolder
]

{ #category : 'accessing' }
CavWindowProfile >> cellSize [

	^ cellSize
]

{ #category : 'accessing' }
CavWindowProfile >> cellSize: aSize [

	cellSize := aSize
]

{ #category : 'adding' }
CavWindowProfile >> hasPlaceHolderFor: aString [

	^ placeHolderDictionary keys includes: aString
]

{ #category : 'initialization' }
CavWindowProfile >> initialize [

	super initialize.
	placeHolderDictionary := Dictionary new.

]

{ #category : 'accessing' }
CavWindowProfile >> name [
	^ profileName
]

{ #category : 'accessing' }
CavWindowProfile >> named: aString [ 
	profileName := aString
]

{ #category : 'accessing' }
CavWindowProfile >> placeHolderDictionnary [

	^ placeHolderDictionary
]

{ #category : 'accessing' }
CavWindowProfile >> placeHolders [
	| res |
	res := OrderedCollection new.
	placeHolderDictionary keysAndValuesDo: [ :k :v | res addAll: v ].
	^ res
]

{ #category : 'accessing' }
CavWindowProfile >> placeHoldersFor: aString [

	^ placeHolderDictionary at: aString ifAbsent: [
		  { (CavNullWindowPlaceHolder new
			   kind: 'Unrecorded';
			   yourself) } ]
]

{ #category : 'initialization' }
CavWindowProfile >> reset [

	placeHolderDictionary := Dictionary new
]
