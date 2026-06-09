Class {
	#name : 'StMethodBrowserDummyClass',
	#superclass : 'Object',
	#traits : 'TData',
	#classTraits : 'TData classTrait',
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Tests'
}

{ #category : 'accessing' }
StMethodBrowserDummyClass >> tmpOtherCaller [

	^ self tmpRecursiveMethod2
]

{ #category : 'accessing' }
StMethodBrowserDummyClass >> tmpRecursiveA [

	^ self tmpRecursiveA
]

{ #category : 'accessing' }
StMethodBrowserDummyClass >> tmpRecursiveB [

	^ self tmpRecursiveB
]

{ #category : 'accessing' }
StMethodBrowserDummyClass >> tmpRecursiveMethod [

	^ self tmpRecursiveMethod 
]

{ #category : 'accessing' }
StMethodBrowserDummyClass >> tmpRecursiveMethod2 [

	^ self tmpRecursiveMethod2
]
