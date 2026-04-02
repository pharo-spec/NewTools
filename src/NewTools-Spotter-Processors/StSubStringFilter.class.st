"
I implement a simple substring string filter using includesSubstring:.
"
Class {
	#name : 'StSubStringFilter',
	#superclass : 'StAbstractStringFilter',
	#category : 'NewTools-Spotter-Processors-Iterators',
	#package : 'NewTools-Spotter-Processors',
	#tag : 'Iterators'
}

{ #category : 'protected' }
StSubStringFilter >> criterium: aValue [

	^ aValue asString includesSubstring: filteringText caseSensitive: false
]

{ #category : 'filtering' }
StSubStringFilter >> substringFilter: aString [
	
	self filteringText: aString
]
