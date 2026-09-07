"
I wrap a StPackageEntry entry name, then later use PackageOrganizer to look for the package (look for self >> content to see the implementation)
"
Class {
	#name : 'StHistoryPackageEntry',
	#superclass : 'StHistoryEntry',
	#instVars : [
		'contentName'
	],
	#category : 'NewTools-Pulse-Entries',
	#package : 'NewTools-Pulse',
	#tag : 'Entries'
}

{ #category : 'instance creation' }
StHistoryPackageEntry class >> new [

	^ self basicNew
]

{ #category : 'instance creation' }
StHistoryPackageEntry class >> new: aStEntry [

	^ self new 
		contentName: aStEntry content name;
		yourself
]

{ #category : 'accessing' }
StHistoryPackageEntry >> content [ 

	^ PackageOrganizer default 
		packageNamed: contentName
		ifAbsent: [ ^ nil ]
]

{ #category : 'accessing' }
StHistoryPackageEntry >> contentName [ 

	^ contentName
]

{ #category : 'accessing' }
StHistoryPackageEntry >> contentName: aSymbol [

	contentName := aSymbol
]

{ #category : 'accessing' }
StHistoryPackageEntry >> contentString [ 
"For compatability"
	^ contentName
]

{ #category : 'printing' }
StHistoryPackageEntry >> displayStringOn: aStream [

	aStream nextPutAll: self contentString
]

{ #category : 'evaluating' }
StHistoryPackageEntry >> doEvaluate [

	self contentEvaluated browse
]

{ #category : 'accessing' }
StHistoryPackageEntry >> iconName [

	^ #package
]
