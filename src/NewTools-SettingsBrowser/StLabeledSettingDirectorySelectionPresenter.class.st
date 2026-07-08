"
Provides a Spec presenter with:

- A label
- An input text displaying a directory.
- A button to select a directory which will update the input text when changed.

"
Class {
	#name : 'StLabeledSettingDirectorySelectionPresenter',
	#superclass : 'StLabeledSettingPresenter',
	#instVars : [
		'selectButtonPresenter'
	],
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'examples' }
StLabeledSettingDirectorySelectionPresenter class >> example [

	^ (self 
		label: 'Label Example' 
		input: SpTextPresenter new
		description: 'Description string') open

]

{ #category : 'layout' }
StLabeledSettingDirectorySelectionPresenter >> buttonWidth [

	^ 100
]

{ #category : 'layout' }
StLabeledSettingDirectorySelectionPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		hAlignStart;
		add: (SpBoxLayout newLeftToRight 
			add: input;
				add: selectButtonPresenter;
				yourself);
		yourself
]

{ #category : 'initialization' }
StLabeledSettingDirectorySelectionPresenter >> initializePresenters [ 

	super initializePresenters.
	selectButtonPresenter := self newButton
		label: 'Select';
		action: [ 
			| selectedDirectory |
			((selectedDirectory := StOpenDirectoryPresenter new openModal) isNotNil and: [ selectedDirectory isDirectory ])
				ifTrue: [ self owner value: selectedDirectory fullName ] ];
		yourself
]

{ #category : 'private' }
StLabeledSettingDirectorySelectionPresenter >> selectButtonPresenter [

	^ selectButtonPresenter
]

{ #category : 'private' }
StLabeledSettingDirectorySelectionPresenter >> selectButtonPresenter: anObject [

	selectButtonPresenter := anObject
]
