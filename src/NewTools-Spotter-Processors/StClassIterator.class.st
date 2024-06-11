"
I implement an iteration over all the classes in the system.

"
Class {
	#name : 'StClassIterator',
	#superclass : 'StGenericGenerator',
	#category : 'NewTools-Spotter-Processors-Iterators',
	#package : 'NewTools-Spotter-Processors',
	#tag : 'Iterators'
}

{ #category : 'enumerating' }
StClassIterator >> elementsDo: aValuable [

	SystemNavigation default allBehaviorsDo: aValuable
]
