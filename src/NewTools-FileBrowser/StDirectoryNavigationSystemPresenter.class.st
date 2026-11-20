"
I am the navigation presenter of the folder dialogs. `StFileNavigationSystemPresenter` describes the navigation presenters.

## Responsibility:

- List only the folders of the current folder, without filter.
- Lay out the navigation buttons and the table without the preview pane.

## Collaborators:

- `StOpenDirectoryPresenter class>>navigationSystemClass`: makes the folder dialogs use me.

## Public API and Key Messages

- `updateFileReferenceTable`: lists the folders.

## Examples

```smalltalk
StOpenDirectoryPresenter example.
```
"
Class {
	#name : 'StDirectoryNavigationSystemPresenter',
	#superclass : 'StFileNavigationSystemPresenter',
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'layout' }
StDirectoryNavigationSystemPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: self navigationLayout expand: false;
		add: self topPaneLayout;
		yourself
]

{ #category : 'utilities' }
StDirectoryNavigationSystemPresenter >> updateFileReferenceTable [
	"Update the receiver's contents according to the current directory and apply configured filters"
	
	fileReferenceTable items: 
		(self currentDirectory children select: [ : c |
			c exists and: [ c isDirectory ]]).
]
