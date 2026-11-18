"
I keep the settings of the file browser and the dialogs, shown in the settings browser under Tools > File Browser. My API is on the class side.

## Life cycle: who sets the settings and who reads them

1. `groupSettingsOn:` and the `…On: aBuilder` methods declare the settings for the settings browser, where the user changes them; the settings button of the dialogs opens it on them.
2. `StFileSystemModel` reads `defaultDirectory` and `showAlwaysDefaultBookmarks`; `StFileNavigationSystemPresenter` reads `openOnLastDirectory`, `showHiddenFiles` and `showPreview`; `StTerminalInterface` reads `macTerminalProgram`.
3. `StFileBrowserToggleHiddenFilesCommand` switches `showHiddenFiles` from the context menu.

## Responsibility:

- Know where the dialogs open: the default folder, or the last visited one.
- Know what the dialogs show: hidden files, preview pane, default bookmarks.
- Know the terminal program to open on macOS.

## Collaborators:

- `StFileSystemModel`, `StFileNavigationSystemPresenter`, `StTerminalInterface`, `StFileBrowserToggleHiddenFilesCommand`: read or change my settings.
- `StSettingsBrowser`: shows them.

## Public API and Key Messages

- `defaultDirectory`, `openOnLastDirectory`, `showHiddenFiles`, `showPreview`, `showAlwaysDefaultBookmarks`, `macTerminalProgram`, each with its setter (e.g. `showHiddenFiles: aBoolean`).

## Examples

```smalltalk
StFileBrowserSettings scriptOpenSettings.
```

## Internal Representation

One class variable per setting, initialized lazily by its getter.
"
Class {
	#name : 'StFileBrowserSettings',
	#superclass : 'Object',
	#classVars : [
		'DefaultDirectory',
		'LinuxTerminalProgram',
		'MacTerminalProgram',
		'OpenOnLastDirectory',
		'ShowAlwaysDefaultBookmarks',
		'ShowHiddenFiles',
		'ShowPreview',
		'WindowsTerminalProgram'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'settings' }
StFileBrowserSettings class >> defaultDirectory [
	"Modified by settings File Browser self classSide >> #openOnDefaultDirectoryOn: "

	^ DefaultDirectory ifNil: [ DefaultDirectory := FileLocator home ]
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
		parentName: #fileBrowser;
		type: #FilePathEncoder;
		defaultValue: self defaultDirectory;
		label: 'Default directory';
		description: 'Set the default directory for opening the file browser and dialogs';
		target: self
]

{ #category : 'settings' }
StFileBrowserSettings class >> defaultTerminalProgram [

	^ 'Terminal'
]

{ #category : 'settings' }
StFileBrowserSettings class >> groupSettingsOn: aBuilder [

	<systemsettings>
	(aBuilder group: #fileBrowser)
		label: 'File Browser';
		description: 'Settings for the File Browser';
		parentName: #tools
]

{ #category : 'settings' }
StFileBrowserSettings class >> linuxTerminalProgram [

	^ LinuxTerminalProgram
		ifNil: [ LinuxTerminalProgram := '' ]
]

{ #category : 'settings' }
StFileBrowserSettings class >> linuxTerminalProgram: aString [

	LinuxTerminalProgram := aString
]

{ #category : 'settings' }
StFileBrowserSettings class >> macTerminalProgram [

	^ MacTerminalProgram
		ifNil: [ MacTerminalProgram := self defaultTerminalProgram ]
]

{ #category : 'settings' }
StFileBrowserSettings class >> macTerminalProgram: aString [

	MacTerminalProgram := aString
]

{ #category : 'settings' }
StFileBrowserSettings class >> macTerminalProgramOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #macTerminalProgram)
		parentName: #fileBrowser;
		defaultValue: String empty;
		label: 'Name of the MacOS terminal';
		description:
			'Set the name of the MacOS terminal program to run when a shell terminal is requested. It is not necessary to specify the full path';
		target: self
]

{ #category : 'settings' }
StFileBrowserSettings class >> openOnLastDirectory [
	"Modified by settings File Browser self classSide >> #openOnLastDirectoryOn: "

	^ OpenOnLastDirectory ifNil: [ OpenOnLastDirectory := true ]
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
		parentName: #fileBrowser;
		label: 'Open on last visited directory';
		description: 'Open a new instance on the last visited directory';
		target: self
]

{ #category : 'script' }
StFileBrowserSettings class >> scriptOpenSettings [
	"Opens the settings browser on the File Browser settings, as the settings button of the file dialogs does."

	<example>
	^ (StSettingsBrowser newApplication: StPharoApplication current)
		  selectPath: #( tools fileBrowser );
		  open
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
		parentName: #fileBrowser;
		defaultValue: true;
		label: 'Show always default bookmarks';
		description: 'If the global bookmarks are deleted, this setting ensures that dialogs will always preserve default bookmarks';
		target: self
]

{ #category : 'accessing' }
StFileBrowserSettings class >> showHiddenFiles [

	^ ShowHiddenFiles ifNil: [ ShowHiddenFiles := false ]
]

{ #category : 'accessing' }
StFileBrowserSettings class >> showHiddenFiles: anObject [

	ShowHiddenFiles := anObject
]

{ #category : 'settings' }
StFileBrowserSettings class >> showHiddenFilesOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #showHiddenFiles)
		parentName: #fileBrowser;
		defaultValue: false;
		label: 'Show hidden files and folders';
		description: 'If enabled, shows the hidden files and folders in the file browser.';
		target: self
]

{ #category : 'accessing' }
StFileBrowserSettings class >> showPreview [

	^ ShowPreview
		ifNil: [ ShowPreview := true ]
]

{ #category : 'accessing' }
StFileBrowserSettings class >> showPreview: aBoolean [
	"Set if File Browsers should display a preview presenter"

	 ShowPreview := aBoolean 
]

{ #category : 'settings' }
StFileBrowserSettings class >> showPreviewOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #showPreview)
		parentName: #fileBrowser;
		defaultValue: true;
		label: 'Enable preview';
		description: 'File Browser will show a preview file presenter by default';
		target: self
]

{ #category : 'settings' }
StFileBrowserSettings class >> windowsTerminalProgram [

	^ WindowsTerminalProgram
		ifNil: [ WindowsTerminalProgram := 'cmd.exe' ]
]

{ #category : 'settings' }
StFileBrowserSettings class >> windowsTerminalProgram: aString [

	WindowsTerminalProgram := aString
]
