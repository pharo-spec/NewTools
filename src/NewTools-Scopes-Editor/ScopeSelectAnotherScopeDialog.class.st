Class {
	#name : 'ScopeSelectAnotherScopeDialog',
	#superclass : 'SpSelectDialog',
	#instVars : [
		'addScopeButton',
		'addScopeButtonAction'
	],
	#category : 'NewTools-Scopes-Editor-GUI',
	#package : 'NewTools-Scopes-Editor',
	#tag : 'GUI'
}

{ #category : 'layout' }
ScopeSelectAnotherScopeDialog class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		borderWidth: 5;
		spacing: 5;
		add: #addScopeButton;
		add: #label expand: false;
		add: #list;
		yourself
]

{ #category : 'accessing' }
ScopeSelectAnotherScopeDialog >> addScopeButtonAction: aBlock [
	addScopeButtonAction
]

{ #category : 'initialization' }
ScopeSelectAnotherScopeDialog >> initializeAddScopeButton [
	addScopeButton
		iconName: #add;
		label: 'New scope';
		action: [ owner newScopeCreator open ]
]

{ #category : 'initialization' }
ScopeSelectAnotherScopeDialog >> initializePresenters [
	super initializePresenters.
	addScopeButton := self newButton.
	
	self initializeAddScopeButton
]
