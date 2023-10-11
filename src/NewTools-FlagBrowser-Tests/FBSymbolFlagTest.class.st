"
A FBSymbolFlagTest is a test class for testing the behavior of FBSymbolFlag
"
Class {
	#name : 'FBSymbolFlagTest',
	#superclass : 'FBFlagTest',
	#category : 'NewTools-FlagBrowser-Tests-Base',
	#package : 'NewTools-FlagBrowser-Tests',
	#tag : 'Base'
}

{ #category : 'accessing' }
FBSymbolFlagTest >> actualClass [
	^ FBSymbolFlag
]

{ #category : 'helpers' }
FBSymbolFlagTest >> defaultParameter [
	^ #test
]

{ #category : 'helpers' }
FBSymbolFlagTest >> insensitiveParameter [
	^ #Test
]
