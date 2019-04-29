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

	^ { ItemsPresenterPort newDelegate: [ self classList ] }
]

{ #category : #initialization }
StSBClassesPanel >> defineOutputPorts [

	^ { ListSelectionPresenterPort newDelegate: [ self classList ] }
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
