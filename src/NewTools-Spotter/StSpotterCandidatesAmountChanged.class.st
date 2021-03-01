Class {
	#name : #StSpotterCandidatesAmountChanged,
	#superclass : #StSpotterAnnouncement,
	#instVars : [
		'amount'
	],
	#category : #'NewTools-Spotter-Model'
}

{ #category : #accessing }
StSpotterCandidatesAmountChanged >> amount [

	^ amount
]

{ #category : #accessing }
StSpotterCandidatesAmountChanged >> amount: anObject [

	amount := anObject
]
