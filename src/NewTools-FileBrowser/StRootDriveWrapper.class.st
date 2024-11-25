"
A root drive as found on Windows
"
Class {
	#name : 'StRootDriveWrapper',
	#superclass : 'StFileSystemItemWrapper',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

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
			  UIManager default inform: 'Missing permissions on ' , fileReference basename.
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
