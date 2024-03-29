"
A FBLocationTest is a test class for testing the behavior of FBLocation
"
Class {
	#name : 'FBLocationTest',
	#superclass : 'TestCase',
	#category : 'NewTools-FlagBrowser-Tests-Base',
	#package : 'NewTools-FlagBrowser-Tests',
	#tag : 'Base'
}

{ #category : 'private' }
FBLocationTest >> defaultLocation [
	^ FBLocation class: self class selector: #defaultLocation interval: (18 to: 90)
]

{ #category : 'tests' }
FBLocationTest >> testCompiledMethod [
	self assert: self defaultLocation compiledMethod equals: self class >> #defaultLocation
]

{ #category : 'tests' }
FBLocationTest >> testPackage [
	self assert: self defaultLocation package equals: self class package
]

{ #category : 'tests' }
FBLocationTest >> testSourceCode [
	self
		assert: self defaultLocation sourceCode
		equals:
			'defaultLocation
	^ FBLocation class: self class selector: #defaultLocation interval: (18 to: 90)'
]
