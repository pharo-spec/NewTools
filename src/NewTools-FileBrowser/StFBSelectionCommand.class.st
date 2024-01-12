Class {
	#name : 'StFBSelectionCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StFBSelectionCommand >> selectedEntry [

	^ self context selectedEntry 
]

{ #category : 'accessing' }
StFBSelectionCommand >> selectedEntryBasename [
	"Answer a <String> with the basename of the selected entry"

	^ self selectedEntry basename
]

{ #category : 'accessing' }
StFBSelectionCommand >> selectedEntryName [

	^ self selectedEntry name
]
