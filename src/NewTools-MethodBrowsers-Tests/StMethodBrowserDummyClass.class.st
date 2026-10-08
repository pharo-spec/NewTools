"
I am a dummy class used as a test subject by StMethodBrowserTest.

I provide the sample methods the method browser tests exercise:
- recursive methods (tmpRecursiveA, tmpRecursiveB, tmpRecursiveMethod, tmpRecursiveMethod2) and a caller (tmpOtherCaller), used to verify recursive-call handling in the senders browser;
- use of the TData trait, so tests can check that browsing senders of a trait method returns the trait itself (TData) and not this trait-using class.
"
Class {
	#name : 'StMethodBrowserDummyClass',
	#superclass : 'Object',
	#traits : 'TSendersFixture',
	#classTraits : 'TSendersFixture classTrait',
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers-Tests'
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
