"
Description
--------------------

I represent a flag which parameter is a Symbol.
"
Class {
	#name : 'FBSymbolFlag',
	#superclass : 'FBFlag',
	#category : 'NewTools-FlagBrowser-Model',
	#package : 'NewTools-FlagBrowser',
	#tag : 'Model'
}

{ #category : 'testing' }
FBSymbolFlag class >> matchesArgument: aFlagArgument [
	^ aFlagArgument isSymbol
]

{ #category : 'accessing' }
FBSymbolFlag class >> priority [
	^ 20
]

{ #category : 'as yet unclassified' }
FBSymbolFlag class >> title [
	^ 'Symbol flags'
]

{ #category : 'update' }
FBSymbolFlag >> insensitiveParameter [
	self parameter: self parameter asLowercase capitalized asSymbol
]
