"
A root directory as found on Unix or Mac (/)
"
Class {
	#name : #StSimpleRootDirectoryWrapper,
	#superclass : #StSimpleDirectoryWrapper,
	#category : #'NewTools-SimpleFileBrowser-Core'
}

{ #category : #testing }
StSimpleRootDirectoryWrapper >> isRoot [ 
	^true
]
