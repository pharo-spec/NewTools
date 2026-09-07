"
I'm morph to represent a placeholder.
"
Class {
	#name : 'CavVisualPlaceHolderMorph',
	#superclass : 'BorderedMorph',
	#instVars : [
		'placeHolder',
		'kind'
	],
	#category : 'NewTools-Window-Profiles-Morphic',
	#package : 'NewTools-Window-Profiles',
	#tag : 'Morphic'
}

{ #category : 'actions' }
CavVisualPlaceHolderMorph >> changeStrategy [

	| presenter description |
	presenter := SpSelectDialog new
		             title: 'Change Strategy';
		             label:
			             'Current strategy is '
			             , placeHolder strategy class displayString
			             , ' , select the strategy you want to use';
		             items: CavWindowStrategy subclasses;
		             display: [ :each | each title ];
		             onAccept: [ :dialog |
				             placeHolder strategy:
						             dialog presenter selectedItem new.
				             CavroisWindowManager toggleProfilePlaceholders.
				             CavroisWindowManager toggleProfilePlaceholders ].
	description := presenter newText text:
		               presenter list selectedItem comment.
	presenter layout add: description.
	presenter list whenSelectionChangedDo: [
		description text: presenter list selectedItem comment asString ].

	presenter openDialog
]

{ #category : 'event handling' }
CavVisualPlaceHolderMorph >> handleClick: anEvent [

	anEvent yellowButtonPressed
		ifTrue: [ self remove ]
		ifFalse: [ self changeStrategy ]
]

{ #category : 'initialization' }
CavVisualPlaceHolderMorph >> initialize [

	super initialize.
	self borderWidth: 3.
	self borderColor: UITheme current selectionColor.
	self color: (UITheme current lightSelectionColor alpha: 0.2).
	self eventHandler: MorphicEventHandler new.
	self eventHandler on: #mouseDown send: #handleClick: to: self
]

{ #category : 'accessing' }
CavVisualPlaceHolderMorph >> kind [

	^ kind
]

{ #category : 'accessing' }
CavVisualPlaceHolderMorph >> kind: aKind [

	kind := aKind
]

{ #category : 'accessing' }
CavVisualPlaceHolderMorph >> placeHolder [

	^ placeHolder
]

{ #category : 'accessing' }
CavVisualPlaceHolderMorph >> placeHolder: aPlaceHolder [

	placeHolder := aPlaceHolder
]

{ #category : 'removing' }
CavVisualPlaceHolderMorph >> remove [

	| presenter key |
	presenter := SpConfirmDialog new
		             title: 'Remove placeholder';
		             label: 'Are you sure you want to remove it ?';
		             onAccept: [ :dialog |
				             key := CavroisWindowManager current currentProfile
					                    placeHolderDictionnary at: kind.
				             (CavroisWindowManager current currentProfile
					              placeHoldersFor: kind) do: [ :p |
						             p = self placeHolder ifTrue: [ key remove: p ] ].
				             key ifEmpty: [
							             CavroisWindowManager current currentProfile
								             placeHolderDictionnary removeKey: kind ].
				             self delete ].
	presenter openDialog
]
