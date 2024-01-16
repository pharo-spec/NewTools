"
Provides global settings to the File Browser. See class side for details.

"
Class {
	#name : 'StFBSettings',
	#superclass : 'Object',
	#classVars : [
		'DefaultDirectory',
		'OpenOnLastDirectory'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'settings' }
StFBSettings class >> defaultDirectory [
	"Modified by settings File Browser self classSide >> #openOnDefaultDirectoryOn: "

	^ DefaultDirectory
		ifNil: [ DefaultDirectory := FileLocator imageDirectory ]
]

{ #category : 'settings' }
StFBSettings class >> defaultDirectory: aFileReference [
	"Modified by settings File Browser self classSide >> #openOnDefaultDirectoryOn: "

	DefaultDirectory := aFileReference
]

{ #category : 'settings' }
StFBSettings class >> defaultDirectoryOn: aBuilder [
	<systemsettings>

	(aBuilder setting: #defaultDirectory)
		parent: #fileBrowser;
		default: self defaultDirectory;
		label: 'Default directory';
		description: 'Set the default directory for opening the file browser and dialogs';
		target: self

]

{ #category : 'settings' }
StFBSettings class >> groupSettingsOn: aBuilder [
	<systemsettings>

	(aBuilder group: #fileBrowser)
		label: 'File Browser';
		description: 'Settings for the File Browser';
		parent: #tools
]

{ #category : 'settings' }
StFBSettings class >> openOnLastDirectory [
	"Modified by settings File Browser self classSide >> #openOnLastDirectoryOn: "

	^ OpenOnLastDirectory
		ifNil: [ OpenOnLastDirectory := false ]
]

{ #category : 'settings' }
StFBSettings class >> openOnLastDirectory: aBoolean [
	"Modified by settings File Browser self classSide >> #openOnLastDirectoryOn: "

	^ OpenOnLastDirectory := aBoolean
]

{ #category : 'settings' }
StFBSettings class >> openOnLastDirectoryOn: aBuilder [
	<systemsettings>

	(aBuilder setting: #openOnLastDirectory)
		parent: #fileBrowser;
		default: true;
		label: 'Open on last visited directory';
		description: 'Open a new instance on the last visited directory';
		target: self

]
