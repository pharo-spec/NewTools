"
A root drive as found on Windows
"
Class {
	#name : #StSimpleRootDriveWrapper,
	#superclass : #StSimpleFileSystemItemWrapper,
	#category : #'NewTools-SimpleFileBrowser-Core'
}

{ #category : #accessing }
StSimpleRootDriveWrapper class >> icon [ 
	^self iconProvider driveIcon
]

{ #category : #'private accessing' }
StSimpleRootDriveWrapper >> directories [ 
	^(fileReference basename, '\') asFileReference directories
]

{ #category : #testing }
StSimpleRootDriveWrapper >> isRoot [ 
	^true
]

{ #category : #accessing }
StSimpleRootDriveWrapper >> label [

	^self volumeName, ' (' ,super label, ')'
]

{ #category : #accessing }
StSimpleRootDriveWrapper >> volumeName [

	^StSimpleWin32Info getVolumeInfo: self fileReference basename
]
