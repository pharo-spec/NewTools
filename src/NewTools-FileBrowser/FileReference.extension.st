Extension { #name : #FileReference }

{ #category : #'*NewTools-FileBrowser' }
FileReference >> isHiddenInWindows [
	^ (self windowsAttributes & 16r2) = 1
]

{ #category : #'*NewTools-FileBrowser' }
FileReference >> windowsAttributes [
	^ self windowsAttributes: self fullName asWin32WideString 
]

{ #category : #'*NewTools-FileBrowser' }
FileReference >> windowsAttributes: lpFileName [
	^ self ffiCall: #(long GetFileAttributesW #(Win32WideString lpFileName)) library: #kernel32
]
