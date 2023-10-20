"
A filter that executes `String>>#match:` to each item to obtain matching items.
"
Class {
	#name : 'StFilterStringMatch',
	#superclass : 'StUnorderedFilter',
	#category : 'NewTools-Spotter-Filters',
	#package : 'NewTools-Spotter',
	#tag : 'Filters'
}

{ #category : 'private' }
StFilterStringMatch >> isMatchedItem: anItem [
	^ query match: (self itemFilterNameFor: anItem)
]
