Class {
	#name : 'StFBFileSystemModel',
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
StFBFileSystemModel class >> defaultDirectory [

	^ StFBSettings defaultDirectory
]

{ #category : 'utilities' }
StFBFileSystemModel >> createDirectory [
	^ self createDirectory: 'new-folder'
]

{ #category : 'utilities' }
StFBFileSystemModel >> createDirectory: initialName [
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
StFBFileSystemModel >> currentDirectory [

	^ currentDirectory
]

{ #category : 'accessing' }
StFBFileSystemModel >> currentDirectory: aFileReference [

	(aFileReference exists and: [ aFileReference isDirectory ]) ifFalse: [ 
		DirectoryDoesNotExist signalWith: aFileReference ].
	currentDirectory := aFileReference.
	LastVisitedDirectory := currentDirectory
]

{ #category : 'defaults' }
StFBFileSystemModel >> defaultDirectory [
	^ self class defaultDirectory
]

{ #category : 'accessing' }
StFBFileSystemModel >> history [
	^ history
]

{ #category : 'accessing' }
StFBFileSystemModel >> history: aConfigurableHistoryIterator [ 
	history := aConfigurableHistoryIterator
]

{ #category : 'utilities' }
StFBFileSystemModel >> openFolder: aFileReference [

	self history register: self currentDirectory.
]
