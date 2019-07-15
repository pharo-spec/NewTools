Class {
	#name : #SpDynamicToolbar,
	#superclass : #SpPresenter,
	#traits : 'TSpDynamicPresenter',
	#classTraits : 'TSpDynamicPresenter classTrait',
	#category : #'NewTools-Debugger-View'
}

{ #category : #'actions lookup' }
SpDynamicToolbar >> actions [ 	
	^self owner actions 
]

{ #category : #initialization }
SpDynamicToolbar >> buttonFor: anAction [
	^ self newButton
		action: anAction;
		label: anAction label;
		yourself
]

{ #category : #initialization }
SpDynamicToolbar >> initializeWidgets [
	
]

{ #category : #'actions lookup' }
SpDynamicToolbar >> layout [
	| row |
	row := SpBoxLayout newHorizontal.
	self basicPresenters keysDo: [ :id | row add: id ].
	^ row
]

{ #category : #initialization }
SpDynamicToolbar >> refreshWidgets [
	self actions do: [ :action | self presenterAt: action id put: (self buttonFor: action) ].
	self presentersDo: [ :button | self focusOrder add: button ]
]

{ #category : #'actions lookup' }
SpDynamicToolbar >> session [ 	
	^self owner session 
]

{ #category : #updating }
SpDynamicToolbar >> update [
	self refreshWidgets.
	super update
]
