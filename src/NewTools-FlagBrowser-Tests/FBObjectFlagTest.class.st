"
A FBObjectFlagTest is a test class for testing the behavior of FBObjectFlag
"
Class {
	#name : 'FBObjectFlagTest',
	#superclass : 'FBFlagTest',
	#category : 'NewTools-FlagBrowser-Tests-Base',
	#package : 'NewTools-FlagBrowser-Tests',
	#tag : 'Base'
}

{ #category : 'accessing' }
FBObjectFlagTest >> actualClass [
	^ FBObjectFlag
]

{ #category : 'helpers' }
FBObjectFlagTest >> defaultParameter [
	^ FBMock new
]

{ #category : 'helpers' }
FBObjectFlagTest >> insensitiveParameter [
	^ self defaultParameter
]
