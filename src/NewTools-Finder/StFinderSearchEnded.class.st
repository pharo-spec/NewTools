"
A SearchEnded is an announcement raised when a search has ended.
"
Class {
	#name : 'StFinderSearchEnded',
	#superclass : 'Announcement',
	#instVars : [
		'results',
		'time'
	],
	#category : 'NewTools-Finder-Announcement',
	#package : 'NewTools-Finder',
	#tag : 'Announcement'
}

{ #category : 'accessing' }
StFinderSearchEnded class >> results: anObject [

	^ self new results: anObject; yourself
]

{ #category : 'accessing' }
StFinderSearchEnded class >> results: anObject time: aTime [

	^ self new 
		results: anObject; 
		time: aTime;
		yourself
]

{ #category : 'accessing' }
StFinderSearchEnded >> results [

	^ results
]

{ #category : 'accessing' }
StFinderSearchEnded >> results: anObject [

	results := anObject
]

{ #category : 'accessing' }
StFinderSearchEnded >> time [

	^ time
]

{ #category : 'accessing' }
StFinderSearchEnded >> time: aTimeInMs [

	time := aTimeInMs 
]
