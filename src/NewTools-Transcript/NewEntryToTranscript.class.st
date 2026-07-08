"
An announcement to communicate the addition of new entries to the presenter
"
Class {
	#name : 'NewEntryToTranscript',
	#superclass : 'Announcement',
	#instVars : [
		'entry'
	],
	#category : 'NewTools-Transcript-Announcements',
	#package : 'NewTools-Transcript',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
NewEntryToTranscript >> entry [ 
	
	^ entry
]

{ #category : 'accessing' }
NewEntryToTranscript >> entry: aString [

	entry := aString
]
