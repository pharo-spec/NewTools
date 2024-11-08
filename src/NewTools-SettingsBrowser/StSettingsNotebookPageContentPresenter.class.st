"
This is the **provider** of a `SpNotebookPage` in a category of the Settings Browser. The notebook pages are contained in a `StSettingsDetailsPresenter`.
"
Class {
	#name : 'StSettingsNotebookPageContentPresenter',
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
StSettingsNotebookPageContentPresenter >> add: aStSettingSectionPresenter expand: aBoolean [ 
	
	settingsBox add: aStSettingSectionPresenter expand: aBoolean 
]

{ #category : 'layout' }
StSettingsNotebookPageContentPresenter >> defaultLayout [

	^ SpScrollableLayout with: settingsBox
		
]

{ #category : 'initialization' }
StSettingsNotebookPageContentPresenter >> initializePresenters [

	settingsBox := SpBoxLayout newTopToBottom 
			spacing: 5;
			yourself
]

{ #category : 'accessing' }
StSettingsNotebookPageContentPresenter >> pagePresenter [
	"Answer the receiver's <StSettingsPagePresenter>"

	^ self owner owner
]

{ #category : 'accessing' }
StSettingsNotebookPageContentPresenter >> parentNode [

	^ parentNode
]

{ #category : 'printing' }
StSettingsNotebookPageContentPresenter >> printOn: aStream [

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
StSettingsNotebookPageContentPresenter >> removeAll [
	"Remove all presenters in the layout"

	settingsBox removeAll
]

{ #category : 'accessing - model' }
StSettingsNotebookPageContentPresenter >> setModelBeforeInitialization: aNode [

	parentNode := aNode
]
