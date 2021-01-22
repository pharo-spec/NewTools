Class {
	#name : #StSpotterCandidateAdded,
	#superclass : #StSpotterAnnouncement,
	#instVars : [
		'candidateLink'
	],
	#category : #'NewTools-Spotter-Model'
}

{ #category : #accessing }
StSpotterCandidateAdded >> candidate [
	^ candidateLink value
]

{ #category : #accessing }
StSpotterCandidateAdded >> candidateLink [

	^ candidateLink
]

{ #category : #accessing }
StSpotterCandidateAdded >> candidateLink: anObject [
	candidateLink := anObject
]
