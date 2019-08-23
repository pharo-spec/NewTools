Extension { #name : #FileReference }

{ #category : #'*NewTools-FileDialog' }
FileReference >> isHiddenInWindows [
	^ (self windowAttributes & 16r2) = 1
]

{ #category : #'*NewTools-FileDialog' }
FileReference >> windowAttributes [
	^ self windowAttributes: self fullName
]

{ #category : #'*NewTools-FileDialog' }
FileReference >> windowAttributes: lpFileName [
	^ self ffiCall: #(long GetFileAttributesW #(char * lpFileName))
]
