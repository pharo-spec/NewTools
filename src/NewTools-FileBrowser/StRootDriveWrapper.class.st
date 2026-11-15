"
I wrap a drive of Windows, a root of the directory tree there. `StFileSystemItemWrapper` describes how wrappers are created and used.

## Responsibility:

- Show the volume name and the drive letter as label, e.g. 'System (C:)'.
- Show the drive icon, and tell that I am a root.
- Answer no subdirectories, and tell the user, when the drive cannot be read.

## Collaborators:

- `StFileSystemItemWrapper class>>roots`: creates me for each readable drive on Windows.
- `StWin32Info`: gives the volume name.

## Public API and Key Messages

- `label`, `volumeName`, `isRoot`, `directories`.

## Examples

```smalltalk
StRootDriveWrapper exampleDriveC.
```

Only ask its label on Windows.
"
Class {
	#name : 'StRootDriveWrapper',
	#superclass : 'StFileSystemItemWrapper',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'examples' }
StRootDriveWrapper class >> exampleDriveC [
	"The drive C: of Windows. Its label asks Windows for the volume name, so only send it on Windows."

	<sampleInstance>
	^ self on: FileSystem root / 'C:'
]

{ #category : 'accessing' }
StRootDriveWrapper class >> icon [ 
	^self iconProvider driveIcon
]

{ #category : 'private - accessing' }
StRootDriveWrapper >> directories [
	"We catch errors because we might not have the rights on the drives and in that case we will get an error.
	This mecanism should probably be generalized."

	^ [ (fileReference basename , '\') asFileReference directories ]
		  on: FileSystemError
		  do: [
			  StPharoApplication current inform: 'Missing permissions on ' , fileReference basename.
			  #(  ) ]
]

{ #category : 'testing' }
StRootDriveWrapper >> isRoot [ 
	^true
]

{ #category : 'accessing' }
StRootDriveWrapper >> label [

	^ String streamContents: [ : stream |
		stream 
			<< self volumeName;
			<< ' (';
			<< super label;
			<< ')' ]
]

{ #category : 'accessing' }
StRootDriveWrapper >> volumeName [

	^ StWin32Info getVolumeInfo: self fileReference basename
]
