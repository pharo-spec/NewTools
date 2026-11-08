"
Wrapper for settings containing a directory `FileReference` type.
"
Class {
	#name : 'StSettingDirectoryPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingDirectoryPresenterItem >> initializePresenters [

	setterPresenter := self newTextInput
		                   beEditable;
		                   placeholder: self model label;
		                   yourself.
	super initializePresenters
]

{ #category : 'initialization' }
StSettingDirectoryPresenterItem >> labeledPresenterClass [

	^ StLabeledSettingDirectorySelectionPresenter

]

{ #category : 'accessing' }
StSettingDirectoryPresenterItem >> settingStyle [

	^ 'itemDirectory'
]

{ #category : 'accessing' }
StSettingDirectoryPresenterItem >> value: aFileReference [ 
	"Set the receiver's value to aString"

	self setterPresenter 
		help: aFileReference asString;
		text: aFileReference asString
]
