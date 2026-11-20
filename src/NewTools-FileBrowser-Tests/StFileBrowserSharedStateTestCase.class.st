"
I am the abstract root of the file browser tests that open browsers, dialogs or models. Such tests change the state shared by all the file dialogs: the bookmarks and the last visited directory of `StFileSystemModel`. I save that state before each test and restore it after, so that the user finds the dialogs as they were.

## Responsibility:

- Save the shared state of `StFileSystemModel` in `setUp` and restore it in `tearDown`.

## Collaborators:

- `StFileSystemModel class>>sharedState` and `restoreSharedState:`: copy and restore the shared state.

## Internal Representation

- `sharedState`: the saved state, as answered by `StFileSystemModel class>>sharedState`.
"
Class {
	#name : 'StFileBrowserSharedStateTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'sharedState'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'testing' }
StFileBrowserSharedStateTestCase class >> isAbstract [

	^ self == StFileBrowserSharedStateTestCase
]

{ #category : 'running' }
StFileBrowserSharedStateTestCase >> setUp [

	super setUp.
	sharedState := StFileSystemModel sharedState
]

{ #category : 'running' }
StFileBrowserSharedStateTestCase >> tearDown [

	StFileSystemModel restoreSharedState: sharedState.
	super tearDown
]
