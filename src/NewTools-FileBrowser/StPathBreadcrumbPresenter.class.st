"
I am the path bar of the file browser and the dialogs: the current folder as links, one per parent folder, and a button to switch to a text field where the user types a path.

## Life cycle: who creates me and who uses me

1. `StFileNavigationSystemPresenter>>initializePresenters` creates me, and its `connectPresenters` asks me to tell it the folder the user chooses (`whenFolderChosenDo:`), to open it (`openFolder:`).
2. Each time its current folder changes (`updateWidgetWithFileReference:`), it gives me the folder with `currentDirectory:`; I show its path and stop any editing, without telling it back. When it gives back the folder I just announced, nothing changes.
3. When the user clicks a link, or types the path of an existing folder and presses Return or the edit button, I show that folder and evaluate the block given to `whenFolderChosenDo:` with it.

I do not depend on my owner: I can be used alone, as `example` does.

## Responsibility:

- Show the path of the current folder as links (`StPathPresenter`), or as text while editing.
- Tell my user which folder was chosen, by link or by typed path.
- Refuse a typed path that is not an existing folder, and keep the text field so that it can be corrected.

## Collaborators:

- `StFileNavigationSystemPresenter`: my owner; gives me the current folder and opens the folder I announce.
- `StPathPresenter`: shows the links.

## Public API and Key Messages

- `currentDirectory: aFileReference`, `currentDirectory`.
- `whenFolderChosenDo: aOneArgBlock`.
- `beginEditing`, `acceptPath: aString`, `cancelEditing`, `isEditing`.

## Examples

```smalltalk
StPathBreadcrumbPresenter example.
```

## Internal Representation

- `currentDirectory`: the `FileReference` shown.
- `folderChosenAction`: the block given to `whenFolderChosenDo:`.
- `path`: the links, a `StPathPresenter`.
- `textInput`: the path text field (`pathTextInput`).
- `editButton`: starts editing, or accepts the typed path while editing.

### Implementation Points

Editing replaces the links by the text field in my layout (`SpBoxLayout>>replace:with:`), and changing the folder replaces the links in the layout of `StPathPresenter`: nothing is rebuilt.
"
Class {
	#name : 'StPathBreadcrumbPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'textInput',
		'editButton',
		'path',
		'currentDirectory',
		'folderChosenAction'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'examples' }
StPathBreadcrumbPresenter class >> example [
	"Opens the path bar alone on the image directory: click a folder to show its path, or the edit button to type one."

	<example>
	| breadcrumb |
	breadcrumb := self new
		              currentDirectory: FileLocator imageDirectory asFileReference;
		              yourself.
	breadcrumb open title: 'Path bar'.
	^ breadcrumb
]

{ #category : 'editing' }
StPathBreadcrumbPresenter >> acceptPath: aString [
	"Choose the folder whose path the user typed. When it is not an existing folder, tell the user and keep the text field, so that the path can be corrected."

	| folder |
	folder := aString asString asFileReference.
	(folder exists and: [ folder isDirectory ]) ifFalse: [ ^ self inform: 'You have to input an existing path to a directory' ].
	self chooseFolder: folder.
	self endEditing
]

{ #category : 'editing' }
StPathBreadcrumbPresenter >> beginEditing [
	"Replace the links by the text field, to let the user type a path."

	self isEditing ifTrue: [ ^ self ].
	self layout replace: path with: textInput.
	textInput
		selectAll;
		takeKeyboardFocus
]

{ #category : 'editing' }
StPathBreadcrumbPresenter >> cancelEditing [
	"Forget what the user typed and show the links again."

	currentDirectory ifNotNil: [ :folder | textInput text: folder fullName ].
	self endEditing
]

{ #category : 'private' }
StPathBreadcrumbPresenter >> chooseFolder: aFileReference [

	self currentDirectory: aFileReference.
	folderChosenAction value: aFileReference
]

{ #category : 'initialization' }
StPathBreadcrumbPresenter >> connectPresenters [

	path action: [ :folder | self chooseFolder: folder ].
	textInput whenSubmitDo: [ :text | self acceptPath: text ].
	editButton action: [
			self isEditing
				ifTrue: [ self acceptPath: textInput text ]
				ifFalse: [ self beginEditing ] ]
]

{ #category : 'accessing' }
StPathBreadcrumbPresenter >> currentDirectory [

	^ currentDirectory
]

{ #category : 'accessing' }
StPathBreadcrumbPresenter >> currentDirectory: aFolder [
	"Show the path of aFolder, as links and in the text field, without announcing it. Stop any editing: the user's typed path no longer applies. Nothing is rebuilt when aFolder is already shown, as when my owner gives back the folder I just announced."

	aFolder = currentDirectory ifTrue: [ ^ self ].
	currentDirectory := aFolder.
	self endEditing.
	textInput text: aFolder fullName.
	path file: aFolder
]

{ #category : 'layout' }
StPathBreadcrumbPresenter >> defaultLayout [
	"The links are shown; while editing, the text field takes their place in this same layout (see beginEditing)."

	^ SpBoxLayout newLeftToRight
		  vAlignCenter;
		  add: path;
		  add: editButton
		  expand: false
		  fill: false
		  padding: 0;
		  yourself
]

{ #category : 'accessing' }
StPathBreadcrumbPresenter >> editButton [

	^ editButton
]

{ #category : 'private' }
StPathBreadcrumbPresenter >> endEditing [

	self isEditing ifFalse: [ ^ self ].
	self layout replace: textInput with: path
]

{ #category : 'initialization' }
StPathBreadcrumbPresenter >> initializePresenters [

	path := self instantiate: StPathPresenter.
	textInput := self newTextInput.
	editButton := self newButton.
	folderChosenAction := [ :folder |  ].

	textInput placeholder: 'path/to/folder'.
	editButton
		addStyle: 'small';
		icon: (self application iconNamed: #edit);
		help: 'Edit the path to the current folder'
]

{ #category : 'editing' }
StPathBreadcrumbPresenter >> isEditing [

	^ self layout presenters includes: textInput
]

{ #category : 'accessing' }
StPathBreadcrumbPresenter >> path [
	^ path
]

{ #category : 'accessing' }
StPathBreadcrumbPresenter >> pathTextInput [

	^ textInput
]

{ #category : 'api - events' }
StPathBreadcrumbPresenter >> whenFolderChosenDo: aOneArgBlock [
	"Evaluate aOneArgBlock with the folder the user chooses, by clicking a link or by typing its path."

	folderChosenAction := aOneArgBlock
]
