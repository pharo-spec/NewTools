"
I show a path as a row of links, one per folder from the root, separated by '/'. Clicking a link evaluates my action with its folder.

## Life cycle: who creates me and who uses me

1. `StPathBreadcrumbPresenter` creates me (`initializePresenters`) and sets my `action:` to choose the clicked folder (`connectPresenters`).
2. Each time the current folder changes, it gives me the folder with `file:`; I replace my links in my layout, so that a displayed path is updated in place.
3. When the user clicks a link, I evaluate my action with the `FileReference` of that link.

## Responsibility:

- Build a link for each folder of a path, the root being shown as 'Root'.
- Evaluate my action with the folder of the clicked link.

## Collaborators:

- `StPathBreadcrumbPresenter`: my owner.

## Public API and Key Messages

- `file: aFileReference`: show the path of a file or folder.
- `action: aOneArgBlock`: what to do with the clicked folder.

## Examples

```smalltalk
StPathPresenter exampleImageDirectory.
```

## Internal Representation

- `action`: a one argument block.
"
Class {
	#name : 'StPathPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'action'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'examples' }
StPathPresenter class >> exampleImageDirectory [
	"Opens the links of the path of the image directory; clicking one inspects its folder."

	<example>
	| path |
	path := self new.
	path
		action: [ :folder | folder inspect ];
		file: FileLocator imageDirectory asFileReference.
	path open title: 'Path of the image directory'.
	^ path
]

{ #category : 'accessing' }
StPathPresenter >> action: aValuable [
	action := aValuable
]

{ #category : 'accessing' }
StPathPresenter >> addLinkTo: aPath [

	^ self addPresenter: (self newLink
			   action: [ action value: aPath asFileReference ];
			   label: (self labelFor: aPath);
			   yourself)
]

{ #category : 'accessing' }
StPathPresenter >> addPresenter: aPresenter [

	self layout
		add: aPresenter
		expand: false
		fill: false
		padding: 0
]

{ #category : 'accessing' }
StPathPresenter >> addSeparator [

	^ self addPresenter: (self newLabel
			   label: '/';
			   yourself)
]

{ #category : 'layout' }
StPathPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
]

{ #category : 'accessing' }
StPathPresenter >> file: aFile [
	"Show the path of aFile. The links are replaced in the layout itself, so that a displayed path is updated without rebuilding."

	| parts |
	self layout removeAll.
	parts := aFile asAbsolute fullPath withParents.
	OSPlatform current isWindows ifTrue: [ parts first isRoot ifTrue: [ parts := parts copyWithoutFirst ] ].
	parts do: [ :each | self addLinkTo: each ] separatedBy: [ self addSeparator ]
]

{ #category : 'accessing' }
StPathPresenter >> labelFor: aPath [

	^ aPath isRoot
		  ifFalse: [ aPath basename ]
		  ifTrue: [ 'Root' ]
]
