Class {
	#name : 'StMCMergeOrLoadChoicePresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'answer',
		'label'
	],
	#category : 'NewTools-Utils',
	#package : 'NewTools-Utils'
}

{ #category : 'layout' }
StMCMergeOrLoadChoicePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: label expand: false;
		  yourself
]

{ #category : 'initialization' }
StMCMergeOrLoadChoicePresenter >> initializeDialogWindow: aDialogWindowPresenter [
	"Used to initialize the model in the case of the use into a dialog window.
	 Override this to set buttons other than the default (Ok, Cancel)."

	aDialogWindowPresenter
		addButton: 'Load' do: [ :presenter |
				answer := true.
				presenter close ];
		addButton: 'Merge' do: [ :presenter |
				answer := false.
				presenter close ];
		addDefaultButton: 'Cancel' do: [ :presenter |
				answer := nil.
				presenter close ]
]

{ #category : 'initialization' }
StMCMergeOrLoadChoicePresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Alert'
]

{ #category : 'accessing' }
StMCMergeOrLoadChoicePresenter >> label: anObject [
	label := anObject
]

{ #category : 'initialization' }
StMCMergeOrLoadChoicePresenter >> requestReslutionWithDescription: aString [

	| dialog |
	self label: aString.
	dialog := self asBlockedDialogWindow.

	dialog open.

	^ answer
]
