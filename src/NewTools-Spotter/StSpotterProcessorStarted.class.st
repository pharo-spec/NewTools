"
Announce a processor execution started.
"
Class {
	#name : 'StSpotterProcessorStarted',
	#superclass : 'Announcement',
	#instVars : [
		'processor'
	],
	#category : 'NewTools-Spotter-Announcements',
	#package : 'NewTools-Spotter',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
StSpotterProcessorStarted class >> newProcessor: aProcessor [

	^ self new 
		processor: aProcessor;
		yourself
]

{ #category : 'accessing' }
StSpotterProcessorStarted >> processor [

	^ processor
]

{ #category : 'accessing' }
StSpotterProcessorStarted >> processor: anObject [

	processor := anObject
]
