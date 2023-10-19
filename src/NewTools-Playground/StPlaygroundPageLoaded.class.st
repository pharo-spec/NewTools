"
Announces when a page has been loaded.
"
Class {
	#name : #StPlaygroundPageLoaded,
	#superclass : #Announcement,
	#instVars : [
		'page'
	],
	#category : #'NewTools-Playground-Model'
}

{ #category : #'instance creation' }
StPlaygroundPageLoaded class >> newPage: aPage [

	^ self new 
		page: aPage;
		yourself
]

{ #category : #accessing }
StPlaygroundPageLoaded >> page [

	^ page
]

{ #category : #accessing }
StPlaygroundPageLoaded >> page: anObject [

	page := anObject
]
