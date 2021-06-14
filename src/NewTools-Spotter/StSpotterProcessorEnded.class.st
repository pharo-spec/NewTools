Class {
	#name : #StSpotterProcessorEnded,
	#superclass : #Announcement,
	#instVars : [
		'processor'
	],
	#category : #'NewTools-Spotter-Announcements'
}

{ #category : #'instance creation' }
StSpotterProcessorEnded class >> newProcessor: aProcessor [

	^ self new 
		processor: aProcessor;
		yourself
]

{ #category : #accessing }
StSpotterProcessorEnded >> processor [

	^ processor
]

{ #category : #accessing }
StSpotterProcessorEnded >> processor: anObject [

	processor := anObject
]
