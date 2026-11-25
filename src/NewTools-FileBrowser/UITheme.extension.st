Extension { #name : 'UITheme' }

{ #category : '*NewTools-FileBrowser' }
UITheme >> chooseDirectoryIn: aThemedMorph title: title path: path [
	"Answer the result of a file dialog with the given title, choosing directories only."

	| dialog |
	dialog := self directoryDialogWindowClass new.

	path ifNotNil: [ dialog defaultFolder: path ].

	dialog
		title: (title ifNil: [ 'Choose Directory' translated ]);
		openModal;
		yourself.


	^ dialog cancelled
		  ifTrue: [ nil ]
		  ifFalse: [ dialog selectedEntry ]
]

{ #category : '*NewTools-FileBrowser' }
UITheme >> chooseExistingFileReferenceIn: aThemedMorph title: title extensions: exts path: path preview: preview [
	"Answer the result of a file name chooser dialog with the given title, extensions
	path and preview type.
	Answer nil or a filename."

	| dialog |
	dialog := self fileDialogWindowClass new.
	exts ifNotNil: [ dialog filter: (StCustomExtensionsFilter extensions: exts) ].
	path ifNotNil: [ dialog nameText: path basename ].
	dialog
		defaultFolder: (path ifNil: [ StFileSystemModel defaultDirectory ]);
		title: (title ifNil: [ 'Choose File' translated ]);
		openModal.

	^ dialog cancelled
		  ifTrue: [ nil ]
		  ifFalse: [ dialog selectedEntry ]
]

{ #category : '*NewTools-FileBrowser' }
UITheme >> chooseFileIn: aThemedMorph title: title extensions: exts path: path preview: preview [
	"Answer the result of a file open dialog with the given title, extensions path and preview type.
	Answer nil or a filename."

	| dialog |
	dialog := self fileDialogWindowClass new.
	exts ifNotNil: [ dialog filter: (StCustomExtensionsFilter extensions: exts) ].
	path ifNotNil: [ dialog nameText: path basename ].
	dialog
		defaultFolder: (path ifNil: [ StFileSystemModel defaultDirectory ]);
		title: (title
				 ifNil: [ 'Choose File' translated ]
				 ifNotNil: [ title ]);
		openModal.

	^ dialog cancelled
		  ifTrue: [ nil ]
		  ifFalse: [ dialog selectedEntry ]
]

{ #category : '*NewTools-FileBrowser' }
UITheme >> chooseForSaveFileReferenceIn: aThemedMorph title: title extensions: exts path: path preview: preview [
	"Answer the result of a file name chooser dialog with the given title, extensions
	path and preview type.
	Answer nil or a filename."

	| dialog directory |
	dialog := self fileSaveDialogWindowClass new.
	exts ifNotNil: [
		dialog filter: (StCustomExtensionsFilter extensions: exts) ].
	path ifNotNil: [
		dialog nameText: path asFileReference nextVersion basename ].
	directory := path
		             ifNil: [ StFileSystemModel defaultDirectory ]
		             ifNotNil: [
				           path asFileReference parent ].

	dialog
		defaultFolder: directory;
		title: (title ifNil: [ 'Save as' ] ifNotNil: [ title ]);
		openModal.

	^ dialog cancelled
		  ifTrue: [ nil ]
		  ifFalse: [ dialog selectedEntry ]
]

{ #category : '*NewTools-FileBrowser' }
UITheme >> chooseFullFileNameIn: aThemedMorph title: title patterns: patterns path: path preview: preview [
	"Answer the result of a file name chooser dialog with the given title, patterns
	path and preview type.
	Answer nil or a filename."

	| dialog |
	dialog := self fileDialogWindowClass new.
	path ifNotNil: [ dialog nameText: path basename ].
	dialog
		defaultFolder: (path ifNil: [ StFileSystemModel defaultDirectory ]);
		title: (title ifNil: [ 'Choose File' translated ]);
		openModal.

	^ dialog cancelled
		  ifTrue: [ nil ]
		  ifFalse: [ dialog selectedEntry ]
]

{ #category : '*NewTools-FileBrowser' }
UITheme >> directoryDialogWindowClass [

	^ StOpenDirectoryPresenter
]

{ #category : '*NewTools-FileBrowser' }
UITheme >> fileDialogWindowClass [

	^ StOpenFilePresenter
]

{ #category : '*NewTools-FileBrowser' }
UITheme >> fileSaveDialogWindowClass [

	^ StSaveFilePresenter
]
