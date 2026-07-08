Class {
	#name : 'StSindarinDebuggerScriptChooserPresenter',
	#superclass : 'SpPresenterWithModel',
	#instVars : [
		'scriptList',
		'filter',
		'chooseElement',
		'loadButton',
		'cancelButton',
		'repository'
	],
	#category : 'NewTools-Sindarin-Tools-Presenters',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Presenters'
}

{ #category : 'actions' }
StSindarinDebuggerScriptChooserPresenter >> applyFilter [

	| filtered |
	filtered := repository scriptsNames select: [ :each |
		            each asLowercase includesSubstring:
			            filter text asLowercase ].
	scriptList items: filtered
]

{ #category : 'accessing' }
StSindarinDebuggerScriptChooserPresenter >> chooseElement [

	^ chooseElement
]

{ #category : 'initialization' }
StSindarinDebuggerScriptChooserPresenter >> connectPresenters [

	scriptList transmitTo: self
]

{ #category : 'layout' }
StSindarinDebuggerScriptChooserPresenter >> defaultLayout [

	| buttonRow |
	buttonRow := SpBoxLayout newLeftToRight
		             spacing: 6;
		             add: #loadButton;
		             add: #cancelButton;
		             yourself.

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: #scriptList;
		  add: #filter expand: false;
		  add: buttonRow expand: false;
		  yourself
]

{ #category : 'initialization' }
StSindarinDebuggerScriptChooserPresenter >> initializePresenters [

	scriptList := self newList.

	filter := self newTextInput.
	filter placeholder: 'Filter ...'.
	filter whenTextChangedDo: [ self applyFilter ].

	loadButton := self newButton.
	loadButton label: 'Load'.

	cancelButton := self newButton.
	cancelButton label: 'Cancel'
]

{ #category : 'accessing' }
StSindarinDebuggerScriptChooserPresenter >> repository: aScriptRepository [

	repository := aScriptRepository.
	self applyFilter
]

{ #category : 'transmission' }
StSindarinDebuggerScriptChooserPresenter >> setModel: aListElement [

	chooseElement := aListElement
]

{ #category : 'actions' }
StSindarinDebuggerScriptChooserPresenter >> whenCancelDo: aBlock [

	cancelButton action: aBlock
]

{ #category : 'actions' }
StSindarinDebuggerScriptChooserPresenter >> whenLoadDo: aBlock [

	loadButton action: aBlock
]
