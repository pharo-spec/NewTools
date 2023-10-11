"
Announces the ammount of candidates found changed.
"
Class {
	#name : 'StSpotterCandidatesAmountChanged',
	#superclass : 'StSpotterAnnouncement',
	#instVars : [
		'amount'
	],
	#category : 'NewTools-Spotter-Announcements',
	#package : 'NewTools-Spotter',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
StSpotterCandidatesAmountChanged >> amount [

	^ amount
]

{ #category : 'accessing' }
StSpotterCandidatesAmountChanged >> amount: anObject [

	amount := anObject
]
