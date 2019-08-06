Class {
	#name : #SpDynamicToolbarPresenter,
	#superclass : #SpPresenter,
	#traits : 'TSpDynamicPresenter',
	#classTraits : 'TSpDynamicPresenter classTrait',
	#instVars : [
		'debugCommands'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
SpDynamicToolbarPresenter class >> defaultSpec [
	<spec: #default>

	^ SpBoxLayout newHorizontal
		add: #debugCommands;
		yourself
]

{ #category : #'actions lookup' }
SpDynamicToolbarPresenter >> actions [ 	
	^self owner toolbarActions
]

{ #category : #initialization }
SpDynamicToolbarPresenter >> initializeWidgets [
	debugCommands := self actions asToolBarPresenter
]

{ #category : #initialization }
SpDynamicToolbarPresenter >> refreshWidgets [
	debugCommands := self actions asToolBarPresenter
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
