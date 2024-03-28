"
Utility to access Win32 functions
"
Class {
	#name : 'StWin32Info',
	#superclass : 'Object',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'examples' }
StWin32Info class >> example [

	(self getVolumeInfo: 'C:') inspect
]

{ #category : 'accessing' }
StWin32Info class >> getVolumeInfo: driveLetter [

	| buffer driveName |
	driveName := (driveLetter, '\\') asWin32WideString.
	buffer := Win32WideString new: 256.
	self getVolumeInfo: driveName into: buffer size: 256.
	^buffer asString
	 
]

{ #category : 'private-ffi' }
StWin32Info class >> getVolumeInfo: volumeName into: lpBuffer size: nSize [
	"Primitive to obtain an environment variable using windows Wide Strings"
	^ self ffiCall: #(uint GetVolumeInformationW (Win32WideString volumeName, Win32WideString lpBuffer, ulong nSize, ulong* nil, ulong* nil, ulong* nil, Win32WideString nil, ulong 0)) module: #kernel32
]
