"
I wrap a HelpTopic entry, to modify its behavior if required for the spotter
"
Class {
	#name : #StHelpEntry,
	#superclass : #StEntry,
	#category : #'NewTools-Spotter-Processors-Entries'
}

{ #category : #converting }
StHelpEntry >> asString [ 

	^ content title
]

{ #category : #evaluating }
StHelpEntry >> doEvaluate [ 

	content stActDefault 
]

{ #category : #accessing }
StHelpEntry >> iconName [
	
	^ content stTopicIconName
]
