Class {
	#name : 'StFileSystemModel',
	#superclass : 'StPresenter',
	#instVars : [
		'currentDirectory',
		'history'
	],
	#classVars : [
		'LastVisitedDirectory'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'defaults' }
StFileSystemModel class >> defaultDirectory [

	^ StFileBrowserSettings defaultDirectory
]

{ #category : 'utilities' }
StFileSystemModel >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : 'utilities' }
StFileSystemModel >> createDirectory: initialName [
	| name path |
	name := (UIManager default
		request: 'Folder name'
		initialAnswer: initialName
		title: 'Create New Folder') ifNil: [ ^ self ].
	path := currentDirectory / name.
	path exists
		ifFalse: [ (currentDirectory / name) ensureCreateDirectory.
			self openFolder: currentDirectory.
			^ self ].
	path isDirectory
		ifTrue: [ UIManager default alert: 'A folder with that name already exists.' ].
	path isFile
		ifTrue: [ UIManager default alert: 'A file with that name already exists.' ].
	self createDirectory: name
]

{ #category : 'accessing' }
StFileSystemModel >> currentDirectory [

	^ currentDirectory
]

{ #category : 'accessing' }
StFileSystemModel >> currentDirectory: aFileReference [

	(aFileReference exists and: [ aFileReference isDirectory ]) 
		ifFalse: [ DirectoryDoesNotExist signalWith: aFileReference ].
	currentDirectory := aFileReference.
	LastVisitedDirectory := currentDirectory
]

{ #category : 'defaults' }
StFileSystemModel >> defaultDirectory [
	^ self class defaultDirectory
]

{ #category : 'accessing' }
StFileSystemModel >> history [
	^ history
]

{ #category : 'accessing' }
StFileSystemModel >> history: aConfigurableHistoryIterator [ 
	history := aConfigurableHistoryIterator
]

{ #category : 'utilities' }
StFileSystemModel >> openFolder: aFileReference [

	self history register: self currentDirectory.
]
