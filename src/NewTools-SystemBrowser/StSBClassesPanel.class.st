Class {
	#name : #StSBClassesPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'classList'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #specs }
StSBClassesPanel class >> defaultSpec [

	^ SpecBoxLayout newVertical 
		add: #classList;
		yourself
]

{ #category : #accessing }
StSBClassesPanel >> classList [
	^ classList
]

{ #category : #initialization }
StSBClassesPanel >> initializePorts [

	self addOutputPort: (ListSelectionPresenterPort new
		delegateTo: [ self classList ];
		yourself).
	self addInputPort: (ItemsPresenterPort new
		delegateTo: [ self classList ];
		yourself)
]

{ #category : #initialization }
StSBClassesPanel >> initializeWidgets [
	
	classList := self newTable
		hideColumnHeaders;
		addColumn: (CompositeTableColumn 
			with: (ImageTableColumn evaluated: #icon)
			with: (StringTableColumn evaluated: #name));
		yourself
]
