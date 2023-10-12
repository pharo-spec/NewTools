Class {
	#name : 'NewScopeAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'scope'
	],
	#category : 'NewTools-Scopes-Announcements',
	#package : 'NewTools-Scopes',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
NewScopeAnnouncement class >> onScope: aScope [

	^ self new
		  scope: aScope;
		  yourself
]

{ #category : 'accessing' }
NewScopeAnnouncement >> scope [

	^ scope
]

{ #category : 'accessing' }
NewScopeAnnouncement >> scope: anObject [

	scope := anObject
]
