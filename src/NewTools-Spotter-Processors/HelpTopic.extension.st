Extension { #name : #HelpTopic }

{ #category : #'*NewTools-Spotter-Processors' }
HelpTopic >> stActDefault [
	HelpBrowser openOn: self
]

{ #category : #'*NewTools-Spotter-Processors' }
HelpTopic >> stAllSubtopics [

	 ^ self subtopics flatCollect: [:aTopic |
		aTopic asOrderedCollection, aTopic stAllSubtopics ]
		 
]

{ #category : #'*NewTools-Spotter-Processors' }
HelpTopic >> stTopicIconName [
	^ self hasSubtopics
		ifTrue: [ #book ]
		ifFalse: [ #page ]
]
