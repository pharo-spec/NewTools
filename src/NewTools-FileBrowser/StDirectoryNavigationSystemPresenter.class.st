"
File Navigation Presenter that will only show directories
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
