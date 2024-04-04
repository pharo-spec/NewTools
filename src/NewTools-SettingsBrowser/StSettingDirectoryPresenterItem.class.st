"
Wrapper for settings containing a directory `FileReference` type.
"
Class {
	#name : 'StSettingDirectoryPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#classTraits : '{} + TraitedClass',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'as yet unclassified' }
StSettingDirectoryPresenterItem >> initializePresenters [

	setterPresenter := self newTextInput 
		beEditable;
		placeholder: self model label;
		yourself.
	labeledPresenter := (self instantiate: self labeledPresenterClass on: self) 
		label: self model label;
		description: self model description;
		input: self setterPresenter;
		yourself.
]

{ #category : 'initialization' }
StSettingDirectoryPresenterItem >> labeledPresenterClass [

	^ StLabeledMultiLineDirectorySelectionPresenter

]

{ #category : 'as yet unclassified' }
StSettingDirectoryPresenterItem >> value: aFileReference [ 
	"Set the receiver's value to aString"

	self setterPresenter 
		help: aFileReference asString;
		text: aFileReference
]
