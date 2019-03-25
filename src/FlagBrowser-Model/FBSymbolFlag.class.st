Class {
	#name : #FBSymbolFlag,
	#superclass : #FBFlag,
	#category : #'FlagBrowser-Model'
}

{ #category : #testing }
FBSymbolFlag class >> matchesArgument: aFlagArgument [
	^ aFlagArgument isSymbol
]

{ #category : #accessing }
FBSymbolFlag class >> priority [
	^ 20
]
