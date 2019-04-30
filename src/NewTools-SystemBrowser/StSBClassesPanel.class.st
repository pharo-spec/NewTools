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

	^ SpecBoxLayout newVertical 
		add: #classList;
		yourself
]

{ #category : #accessing }
StSBClassesPanel >> classList [
	^ classList
]

{ #category : #initialization }
StSBClassesPanel >> defineInputPorts [

	^ { SpecListItemsPort newDelegate: [ self classList ] }
]

{ #category : #initialization }
StSBClassesPanel >> defineOutputPorts [

	^ { SpecListSelectionPort newDelegate: [ self classList ] }
]

{ #category : #initialization }
StSBClassesPanel >> initializeWidgets [
	
	classList := self newTable
		hideColumnHeaders;
		addColumn: (CompositeTableColumn 
			with: (ImageTableColumn evaluated: #icon) beNotExpandable
			with: (StringTableColumn evaluated: #name));
		yourself
]
