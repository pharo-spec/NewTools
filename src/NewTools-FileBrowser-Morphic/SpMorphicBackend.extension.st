Extension { #name : 'SpMorphicBackend' }

{ #category : '*NewTools-FileBrowser-Morphic' }
SpMorphicBackend >> executeOpenDirectoryDialog: aFileDialog [

	^ StOpenDirectoryPresenter new
		defaultFolder: (aFileDialog path ifNil: [ StFileSystemModel defaultDirectory ]);
		title: (aFileDialog title ifNil: [ 'Choose Directory' translated ]);
		openModal;
		selectedEntry
]

{ #category : '*NewTools-FileBrowser-Morphic' }
SpMorphicBackend >> executeOpenFileDialog: aFileDialog [
	| dialog |

	dialog := self newFileDialogFor: aFileDialog.
	^ dialog openModal answer 
		ifNotNil: [ :aString | aString asFileReference ]
]

{ #category : '*NewTools-FileBrowser-Morphic' }
SpMorphicBackend >> executeSaveFileDialog: aFileDialog [
	| dialog |

	dialog := self newFileDialogFor: aFileDialog.
	dialog answerSaveFile.
	^ dialog openModal answer 
		ifNotNil: [ :aString | aString asFileReference ]
]

{ #category : '*NewTools-FileBrowser-Morphic' }
SpMorphicBackend >> newFileDialogFor: aFileDialog [
	| dialog dialogClass |
	
	dialogClass := aFileDialog isOpenFile
		ifTrue: [ StOpenFilePresenter ]
		ifFalse: [ StOpenDirectoryPresenter ].
	dialog := dialogClass for: aFileDialog.
	
	aFileDialog path ifNotNil: [ :folder | dialog openFolder: folder ].
	aFileDialog filters ifNotEmpty: [ :filters |
		dialog fileNavigationSystem 
			filter: (StCustomExtensionsFilter extensions: { filters }) ].

	^ dialog
]

{ #category : '*NewTools-FileBrowser-Morphic' }
SpMorphicBackend >> openFileDialog: aFileDialog [

	aFileDialog isOpenFile ifTrue: [ ^ self executeOpenFileDialog: aFileDialog ].
	aFileDialog isOpenDirectory ifTrue: [ ^ self executeOpenDirectoryDialog: aFileDialog ].
	
	^ self executeSaveFileDialog: aFileDialog
]
