"
A root drive as found on Windows
"
Class {
	#name : 'StFBRootDriveWrapper',
	#superclass : 'StFBFileSystemItemWrapper',
	#category : 'NewTools-FileBrowser-Wrappers',
	#package : 'NewTools-FileBrowser',
	#tag : 'Wrappers'
}

{ #category : 'accessing' }
StFBRootDriveWrapper class >> icon [ 
	^self iconProvider driveIcon
]

{ #category : 'private - accessing' }
StFBRootDriveWrapper >> directories [ 
	^(fileReference basename, '\') asFileReference directories
]

{ #category : 'testing' }
StFBRootDriveWrapper >> isRoot [ 
	^true
]

{ #category : 'accessing' }
StFBRootDriveWrapper >> label [

	^ String streamContents: [ : stream |
		stream 
			<< self volumeName;
			<< ' (';
			<< super label;
			<< ')' ]
]

{ #category : 'accessing' }
StFBRootDriveWrapper >> volumeName [

	^ StFBWin32Info getVolumeInfo: self fileReference basename
]
