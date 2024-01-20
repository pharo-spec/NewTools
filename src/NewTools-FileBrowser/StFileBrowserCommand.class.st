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
