Class {
	#name : 'HCBrowser',
	#superclass : 'ComposablePresenter',
	#instVars : [
		'listItems',
		'docReader'
	],
	#category : 'HelpCenter',
	#package : 'HelpCenter'
}

{ #category : 'specs' }
HCBrowser class >> defaultSpec [
	^SpecRowLayout composed
		newColumn: [ :col | col add: #listItems ] origin: 0 @ 0 corner: 0.3 @ 1;
		newColumn: [ :col | col add: #docReader ];
		yourself

]

{ #category : 'accessing' }
HCBrowser >> docReader [
	^ docReader
]

{ #category : 'accessing' }
HCBrowser >> docReader: anObject [
	docReader := anObject
]

{ #category : 'initialization' }
HCBrowser >> initializePresenter [
]

{ #category : 'initialization' }
HCBrowser >> initializeWidgets [
	listItems := self newList.
	docReader := self newText.

]

{ #category : 'accessing' }
HCBrowser >> listItems [
	^ listItems
]

{ #category : 'accessing' }
HCBrowser >> listItems: anObject [
	listItems := anObject
]

{ #category : 'initialization' }
HCBrowser >> title [
	^'HCBrowser'
]
