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

	^ { SpSelectionPort newDelegate: [ self classList ] }
]

{ #category : #accessing }
StSBClassesPanel >> gotoClass: aClass [
	| items classModel |

	items := self classList items. 
	classModel := items
		detect: [ :each | each modelClass = aClass ]
		ifNone: [ ^ self ].
		
	self classList selectItem: classModel
]

{ #category : #initialization }
StSBClassesPanel >> initializePresenters [
	
	classList := self newTable
		hideColumnHeaders;
		addColumn: (SpCompositeTableColumn 
			with: (SpImageTableColumn evaluated: #icon) beNotExpandable
			with: (SpStringTableColumn evaluated: #name));
		yourself
]
