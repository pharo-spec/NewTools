Class {
	#name : 'StFBFileWrapper',
	#superclass : 'StFBFileSystemItemWrapper',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'testing' }
StFBFileWrapper >> isFile [

	^ true
]

{ #category : 'private - accessing' }
StFBFileWrapper >> size [
	
	^ [ fileReference size asString ] on: FileDoesNotExistException do: [ 0 ]
]
