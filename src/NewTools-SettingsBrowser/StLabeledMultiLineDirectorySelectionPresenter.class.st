"
Provides a Spec presenter with:

- A label
- An input text displaying a directory.
- A button to select a directory which will update the input text when changed.

"
Class {
	#name : 'StLabeledMultiLineDirectorySelectionPresenter',
	#superclass : 'StLabeledMultiLinePresenter',
	#instVars : [
		'selectButtonPresenter'
	],
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'examples' }
StLabeledMultiLineDirectorySelectionPresenter class >> example [

	^ (self 
		label: 'Label Example' 
		input: SpTextPresenter new
		description: 'Description string') open

]

{ #category : 'layout' }
StLabeledMultiLineDirectorySelectionPresenter >> buttonWidth [

	^ 100
]

{ #category : 'layout' }
StLabeledMultiLineDirectorySelectionPresenter >> defaultLayout [
	^ SpBoxLayout newLeftToRight
		add: labelPresenter withConstraints: [ :constraints | constraints width: self labelWidth ];
		add:
			(SpBoxLayout newTopToBottom
				add: (SpBoxLayout newLeftToRight 
					add: input withConstraints: [ :constraints | 
						constraints 
							width: self inputTextWidth;
							height: self inputTextHeight ];
					add: selectButtonPresenter withConstraints: [ :constraints | 
						constraints width: self buttonWidth ]);
				add: descriptionPresenter withConstraints: [ :constraints | 
					constraints 
						height: self inputTextHeight * 2.5 ]) width: self settingBoxWidth;
		yourself
]

{ #category : 'initialization' }
StLabeledMultiLineDirectorySelectionPresenter >> initializePresenters [ 

	super initializePresenters.
	selectButtonPresenter := self newButton
		label: 'Select Directory';
		action: [ 
			| selectedDirectory |
			((selectedDirectory := StOpenDirectoryPresenter new openModal) notNil and: [ selectedDirectory isDirectory ])
				ifTrue: [ 
					self input 
						text: selectedDirectory fullName;
						help: selectedDirectory fullName ] ];
		yourself
]

{ #category : 'private' }
StLabeledMultiLineDirectorySelectionPresenter >> selectButtonPresenter [

	^ selectButtonPresenter
]

{ #category : 'private' }
StLabeledMultiLineDirectorySelectionPresenter >> selectButtonPresenter: anObject [

	selectButtonPresenter := anObject
]
