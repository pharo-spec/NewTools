"
Abstract Commander class to group File Browser commands behavior.

"
Class {
	#name : 'StFileBrowserCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StFileBrowserCommand >> iconProvider [ 

	^ StFileBrowserIconCache 
]
