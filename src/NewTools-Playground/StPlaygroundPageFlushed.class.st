"
Announces when a page is just flushed (saved to disk, generated a new version)
"
Class {
	#name : 'StPlaygroundPageFlushed',
	#superclass : 'Announcement',
	#instVars : [
		'page'
	],
	#category : 'NewTools-Playground-Model',
	#package : 'NewTools-Playground',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StPlaygroundPageFlushed class >> newPage: aPage [

	^ self new 
		page: aPage;
		yourself
]

{ #category : 'accessing' }
StPlaygroundPageFlushed >> page [

	^ page
]

{ #category : 'accessing' }
StPlaygroundPageFlushed >> page: anObject [

	page := anObject
]
