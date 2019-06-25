Class {
	#name : #StSBClassesPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'classList'
	],
	#category : #'NewTools-SystemBrowser-View'
}

{ #category : #specs }
StSBClassesPanel class >> defaultSpec [

	^ SpBoxLayout newVertical 
		add: #classList;
		yourself
]

{ #category : #accessing }
StSBClassesPanel >> classList [
	^ classList
]

{ #category : #initialization }
StSBClassesPanel >> defineInputPorts [

	^ { SpListItemsPort newDelegate: [ self classList ] }
]

{ #category : #initialization }
StSBClassesPanel >> defineOutputPorts [

	^ { SpListSelectionPort newDelegate: [ self classList ] }
]

{ #category : #initialization }
StSBClassesPanel >> initializeWidgets [
	
	classList := self newTable
		hideColumnHeaders;
		addColumn: (SpCompositeTableColumn 
			with: (SpImageTableColumn evaluated: #icon) beNotExpandable
			with: (SpStringTableColumn evaluated: #name));
		yourself
]
