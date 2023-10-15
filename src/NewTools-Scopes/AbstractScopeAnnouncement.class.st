Class {
	#name : 'AbstractScopeAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'scope'
	],
	#category : 'NewTools-Scopes-Announcements',
	#package : 'NewTools-Scopes',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
AbstractScopeAnnouncement class >> onScope: aScope [

	^ self new
		  scope: aScope;
		  yourself
]

{ #category : 'accessing' }
AbstractScopeAnnouncement >> scope [

	^ scope
]

{ #category : 'accessing' }
AbstractScopeAnnouncement >> scope: anObject [

	scope := anObject
]
