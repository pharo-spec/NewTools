"
It mostly redefines file specific behavior for file system items in a File Browser.

"
Class {
	#name : 'StFileWrapper',
	#superclass : 'StFileSystemItemWrapper',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'testing' }
StFileWrapper >> isFile [

	^ true
]

{ #category : 'private - accessing' }
StFileWrapper >> size [
	
	^ [ fileReference size asString ] on: FileDoesNotExistException do: [ 0 ]
]
