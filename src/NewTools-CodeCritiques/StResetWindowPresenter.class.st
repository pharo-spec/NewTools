"
I am a UI with two options to reset the currently analysed model.

* If you select 'Reset Current Configuration', I will open the StCritiquePackageSelectorPresenter to set a new configuration.
* If you select 'Uses Current Configuration', I will open the StCritiqueBrowserPresenter with the last configuration of selected packages and selected rules.

You can open me whit:
`StResetWindowPresenter open`.
"
Class {
	#name : #StResetWindowPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'resetModel',
		'currentConfigurationModel'
	],
	#category : #'NewTools-CodeCritiques-Parts'
}

{ #category : #specs }
StResetWindowPresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #resetModel;
				   add: #currentConfigurationModel;
				   yourself)
		  height: 25
]

{ #category : #specs }
StResetWindowPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #specs }
StResetWindowPresenter class >> title [
	^ 'Critique Browser' 
]

{ #category : #accessing }
StResetWindowPresenter >> currentConfigurationModel [
	^ currentConfigurationModel
]

{ #category : #initialization }
StResetWindowPresenter >> initializePresenters [

	resetModel := self newButton.
	currentConfigurationModel := self newButton.

	self setFocusOrder.
	self setResetModel.
	self setCurrentConfigurationModel
]

{ #category : #initialization }
StResetWindowPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title:  self title;
		initialExtent: 450@30
]

{ #category : #initialization }
StResetWindowPresenter >> openCurrentConfiguration [

	StCritiqueBrowserPresenter openOnWorkingConfiguration:
		  CBCritiqueWorkingConfiguration current
]

{ #category : #initialization }
StResetWindowPresenter >> openPackagesChooser [

	^ StCritiquePackageSelectorPresenter open
]

{ #category : #accessing }
StResetWindowPresenter >> resetModel [
	^ resetModel
]

{ #category : #initialization }
StResetWindowPresenter >> setCurrentConfigurationModel [

	currentConfigurationModel
		state: false;
		label: 'Uses Current Configuration';
		action: [ self openCurrentConfiguration. self delete ]
]

{ #category : #initialization }
StResetWindowPresenter >> setFocusOrder [

	self focusOrder
		add: resetModel;
		add: currentConfigurationModel
]

{ #category : #initialization }
StResetWindowPresenter >> setResetModel [

	resetModel
		state: false;
		label: 'Reset Current Configurartion';
		action: [ 
			self openPackagesChooser.
			self delete ]
]
