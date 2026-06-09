Class {
	#name : 'StMethodBrowserData',
	#superclass : 'Object',
	#traits : 'TData',
	#classTraits : 'TData classTrait',
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Tests'
}

{ #category : 'accessing' }
StMethodBrowserData >> tmpOtherCaller [

	^ self tmpRecursiveMethod2
]

{ #category : 'accessing' }
StMethodBrowserData >> tmpRecursiveMethod [

	^ self tmpRecursiveMethod
]

{ #category : 'accessing' }
StMethodBrowserData >> tmpRecursiveMethod2 [

	^ self tmpRecursiveMethod2
]
