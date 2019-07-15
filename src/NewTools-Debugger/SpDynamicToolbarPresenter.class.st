Class {
	#name : #SpDynamicToolbarPresenter,
	#superclass : #SpPresenter,
	#traits : 'TSpDynamicPresenter',
	#classTraits : 'TSpDynamicPresenter classTrait',
	#category : #'NewTools-Debugger-View'
}

{ #category : #'actions lookup' }
SpDynamicToolbarPresenter >> actions [ 	
	^self owner actions 
]

{ #category : #initialization }
SpDynamicToolbarPresenter >> buttonFor: anAction [
	^ self newButton
		action: anAction;
		label: anAction label;
		yourself
]

{ #category : #initialization }
SpDynamicToolbarPresenter >> initializeWidgets [
	
]

{ #category : #'actions lookup' }
SpDynamicToolbarPresenter >> layout [
	| row |
	row := SpBoxLayout newHorizontal.
	self basicPresenters keysDo: [ :id | row add: id ].
	^ row
]

{ #category : #initialization }
SpDynamicToolbarPresenter >> refreshWidgets [
	self actions do: [ :action | self presenterAt: action id put: (self buttonFor: action) ].
	self presentersDo: [ :button | self focusOrder add: button ]
]

{ #category : #'actions lookup' }
SpDynamicToolbarPresenter >> session [ 	
	^self owner session 
]

{ #category : #updating }
SpDynamicToolbarPresenter >> update [
	self refreshWidgets.
	super update
]
