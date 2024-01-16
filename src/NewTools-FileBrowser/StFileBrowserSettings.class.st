"
Provides global settings to the File Browser. See class side for details.

"
Class {
	#name : 'StFileBrowserSettings',
	#superclass : 'Object',
	#classVars : [
		'DefaultDirectory',
		'OpenOnLastDirectory',
		'ShowAlwaysDefaultBookmarks'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'settings' }
StFileBrowserSettings class >> defaultDirectory [
	"Modified by settings File Browser self classSide >> #openOnDefaultDirectoryOn: "

	^ DefaultDirectory
		ifNil: [ DefaultDirectory := FileLocator imageDirectory ]
]

{ #category : 'settings' }
StFileBrowserSettings class >> defaultDirectory: aFileReference [
	"Modified by settings File Browser self classSide >> #openOnDefaultDirectoryOn: "

	DefaultDirectory := aFileReference
]

{ #category : 'settings' }
StFileBrowserSettings class >> defaultDirectoryOn: aBuilder [
	<systemsettings>

	(aBuilder setting: #defaultDirectory)
		parent: #fileBrowser;
		type: #FilePathEncoder;
		default: self defaultDirectory;
		label: 'Default directory';
		description: 'Set the default directory for opening the file browser and dialogs';
		target: self

]

{ #category : 'settings' }
StFileBrowserSettings class >> groupSettingsOn: aBuilder [
	<systemsettings>

	(aBuilder group: #fileBrowser)
		label: 'File Browser';
		description: 'Settings for the File Browser';
		parent: #tools
]

{ #category : 'settings' }
StFileBrowserSettings class >> openOnLastDirectory [
	"Modified by settings File Browser self classSide >> #openOnLastDirectoryOn: "

	^ OpenOnLastDirectory
		ifNil: [ OpenOnLastDirectory := false ]
]

{ #category : 'settings' }
StFileBrowserSettings class >> openOnLastDirectory: aBoolean [
	"Modified by settings File Browser self classSide >> #openOnLastDirectoryOn: "

	^ OpenOnLastDirectory := aBoolean
]

{ #category : 'settings' }
StFileBrowserSettings class >> openOnLastDirectoryOn: aBuilder [
	<systemsettings>

	(aBuilder setting: #openOnLastDirectory)
		parent: #fileBrowser;
		default: true;
		label: 'Open on last visited directory';
		description: 'Open a new instance on the last visited directory';
		target: self

]

{ #category : 'settings' }
StFileBrowserSettings class >> showAlwaysDefaultBookmarks [
	"Modified by settings File Browser self classSide >> #showAlwaysDefaultBookmarksOn: "

	^ ShowAlwaysDefaultBookmarks
		ifNil: [ ShowAlwaysDefaultBookmarks := true ]
]

{ #category : 'settings' }
StFileBrowserSettings class >> showAlwaysDefaultBookmarks: aBoolean [
	"Modified by settings File Browser self classSide >> #showAlwaysDefaultBookmarksOn: "

	ShowAlwaysDefaultBookmarks := aBoolean
]

{ #category : 'settings' }
StFileBrowserSettings class >> showAlwaysDefaultBookmarksOn: aBuilder [
	<systemsettings>

	(aBuilder setting: #showAlwaysDefaultBookmarks)
		parent: #fileBrowser;
		default: true;
		label: 'Show always default bookmarks';
		description: 'If the global bookmarks are deleted, this setting ensures that dialogs will always preserve default bookmarks';
		target: self

]
