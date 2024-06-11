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
	^(fileReference basename, '\') asFileReference directories
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
