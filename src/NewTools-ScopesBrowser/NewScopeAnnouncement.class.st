Class {
	#name : 'NewScopeAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'scope'
	],
	#category : 'NewTools-ScopesBrowser-Announcements',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
NewScopeAnnouncement class >> on: aScope [
	^ self new
		scope: aScope;
		yourself
]

{ #category : 'accessing' }
NewScopeAnnouncement >> scope [
	^ scope
]

{ #category : 'accessing' }
NewScopeAnnouncement >> scope: aScope [
	scope := aScope
]
