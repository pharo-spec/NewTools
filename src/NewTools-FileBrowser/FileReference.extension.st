Extension { #name : #FileReference }

{ #category : #'*NewTools-FileBrowser' }
FileReference >> isHiddenInWindows [
	^ (self windowAttributes & 16r2) = 1
]

{ #category : #'*NewTools-FileBrowser' }
FileReference >> windowAttributes [
	^ self windowAttributes: self fullName
]

{ #category : #'*NewTools-FileBrowser' }
FileReference >> windowAttributes: lpFileName [
	^ self ffiCall: #(long GetFileAttributesW #(char * lpFileName))
]
