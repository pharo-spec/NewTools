Class {
	#name : 'ScopeNameEnteredAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'name'
	],
	#category : 'NewTools-ScopesBrowser-Announcements',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
ScopeNameEnteredAnnouncement class >> on: aString [

	^ self new
		  name: aString;
		  yourself
]

{ #category : 'accessing' }
ScopeNameEnteredAnnouncement >> name [

	^ name
]

{ #category : 'accessing' }
ScopeNameEnteredAnnouncement >> name: anObject [

	name := anObject
]
