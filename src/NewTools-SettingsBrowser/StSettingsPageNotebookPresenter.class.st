Class {
	#name : 'StSettingsPageNotebookPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'settingsBox',
		'parentNode'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'adding' }
StSettingsPageNotebookPresenter >> add: aStSettingSectionPresenter expand: aBoolean [ 

	settingsBox add: aStSettingSectionPresenter expand: aBoolean 
]

{ #category : 'layout' }
StSettingsPageNotebookPresenter >> defaultLayout [

	^ SpScrollableLayout with: settingsBox
		
]

{ #category : 'initialization' }
StSettingsPageNotebookPresenter >> initializePresenters [

	settingsBox := SpBoxLayout newTopToBottom 
			spacing: 5;
			yourself
]

{ #category : 'accessing' }
StSettingsPageNotebookPresenter >> parentNode [

	^ parentNode
]

{ #category : 'printing' }
StSettingsPageNotebookPresenter >> printOn: aStream [

	settingsBox
		ifNotNil: [ : sb | 
			super printOn: aStream.
			aStream 
				<< ' (children: ';
				<< sb children size asString;
				<< ')' ]
		ifNil: [ aStream << '(Page with no children yet)' ]
]

{ #category : 'removing' }
StSettingsPageNotebookPresenter >> removeAll [
	"Remove all presenters in the layout"

	settingsBox removeAll
]

{ #category : 'accessing - model' }
StSettingsPageNotebookPresenter >> setModelBeforeInitialization: aNode [

	parentNode := aNode
]
