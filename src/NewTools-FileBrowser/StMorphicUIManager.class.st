"
I override methods related to opening a file dialog to use my own file dialog instead of the system's one.

To use me by default, see class-side.
"
Class {
	#name : 'StMorphicUIManager',
	#superclass : 'MorphicUIManager',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'public' }
StMorphicUIManager class >> beDefault [
	<script>
	self new beDefault
]

{ #category : 'testing' }
StMorphicUIManager class >> isActiveManager [
	"This is just a temporary UI manager and it should not be enabled by the system by default."

	^ false
]

{ #category : 'testing' }
StMorphicUIManager class >> isValidForCurrentSystemConfiguration [

	"Has to return false, otherwise UIManager will select this one as default automatically when the image is opened"

	^ false
]

{ #category : 'ui requests' }
StMorphicUIManager >> chooseDirectory: label from: dir [

	self flag: #ToDoWhenIntegration.
	self flag: 'use chooseDirectory:path: instead of this'.
	^ StOpenDirectoryPresenter new
		defaultFolder: dir;
		title: (label ifNil: [ 'Choose Directory' translated ]);
		open
]

{ #category : 'ui requests' }
StMorphicUIManager >> chooseDirectory: label path: path [

	^ StOpenDirectoryPresenter new
		  defaultFolder: (path ifNil: [ StFileSystemModel defaultDirectory ]);
		  title: (label ifNil: [ 'Choose Directory' translated ]);
		  openModal;
		  selectedEntry
]
