"
It represents a wrapper for an individual setting presenter to provide a more customized presentation in the settings browser. Subclasses may override accordingly to the ""type"" of value to set. For example, this class provides a label and a description presenters, but subclasses may also add a Number or Float presenter for the value to set (see `StSettingNumberPresenterItem` for details).

Subclasses may want to override `#value:` to abstract the way the wrapped presenter is configured, so instead of sending `#number:` or `#text:` clients can use directly `#value:`

The wrapped presenter is hold in `setterPresenter` instance variable.
"
Class {
	#name : 'StSettingPresenterItem',
	#superclass : 'SpPresenter',
	#instVars : [
		'setterPresenter',
		'model',
		'labeledPresenter'
	],
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'layout' }
StSettingPresenterItem >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: labeledPresenter;
		yourself
]

{ #category : 'accessing' }
StSettingPresenterItem >> help: aString [ 

	"To update the pop-up help"
	self setterPresenter help: aString.
	"To update the 'documentation' pane"
	self owner help: aString.
]

{ #category : 'initialization' }
StSettingPresenterItem >> initializePresenters [
	"Set a label and description presenters as baseline for every setting"

	labeledPresenter := (self instantiate: self labeledPresenterClass on: self) 
		label: self model label;
		input: self setterPresenter;
		description: self model description;
		yourself.

]

{ #category : 'initialization' }
StSettingPresenterItem >> labeledPresenterClass [

	^ StLabeledSettingPresenter

]

{ #category : 'accessing' }
StSettingPresenterItem >> model [

	^ model
]

{ #category : 'accessing - model' }
StSettingPresenterItem >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : 'accessing' }
StSettingPresenterItem >> setterPresenter [

	^ setterPresenter
]

{ #category : 'accessing' }
StSettingPresenterItem >> setterPresenter: anObject [

	setterPresenter := anObject
]

{ #category : 'accessing' }
StSettingPresenterItem >> value: anObject [ 
	"Set the receiver's value to anObject"

	self subclassResponsibility
]
