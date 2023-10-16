Class {
	#name : 'FBClassMock',
	#superclass : 'Object',
	#instVars : [
		'isCompileCall'
	],
	#category : 'NewTools-FlagBrowser-Tests-Presenters',
	#package : 'NewTools-FlagBrowser-Tests',
	#tag : 'Presenters'
}

{ #category : 'compiling' }
FBClassMock >> compile: test [
	isCompileCall := true
]

{ #category : 'initialization' }
FBClassMock >> initialize [
	isCompileCall := true
]

{ #category : 'accessing' }
FBClassMock >> isCompileCall [
	^ isCompileCall 
]
