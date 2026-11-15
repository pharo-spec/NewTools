"
I call Windows, through FFI, to get the name of a volume. My API is on the class side; I only work on Windows.

## Life cycle: who uses me

1. On Windows, `StRootDriveWrapper>>label` asks me the volume name of its drive (`volumeName`).
2. I call `GetVolumeInformationW` of `kernel32` and answer the name as a `String`.

## Responsibility:

- Answer the volume name of a drive.

## Collaborators:

- `StRootDriveWrapper`: my only user.
- `Win32WideString`: the strings exchanged with Windows.

## Public API and Key Messages

- `StWin32Info getVolumeInfo: aDriveLetter`, e.g. with `'C:'`.

## Examples

```smalltalk
StWin32Info example.
```

It inspects the volume name of the drive C:, on Windows only.
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
	^ self ffiCall: #(uint GetVolumeInformationW (Win32WideString volumeName, Win32WideString lpBuffer, ulong nSize, void* 0, void* 0, void* 0, Win32WideString 0, ulong 0)) module: #kernel32
]
