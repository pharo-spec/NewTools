"
A file wrapper
"
Class {
	#name : #StSimpleFileWrapper,
	#superclass : #StSimpleFileSystemItemWrapper,
	#category : #'NewTools-SimpleFileBrowser-Core'
}

{ #category : #accessing }
StSimpleFileWrapper class >> icon [ 
	^self iconProvider fileIcon 
]

{ #category : #testing }
StSimpleFileWrapper >> isFile [

	^true
]

{ #category : #accessing }
StSimpleFileWrapper >> size [
	"See https://github.com/pharo-project/pharo/issues/3571"
	
	^[ fileReference size asString ] on: FileDoesNotExistException do: [ 0 ]
]
