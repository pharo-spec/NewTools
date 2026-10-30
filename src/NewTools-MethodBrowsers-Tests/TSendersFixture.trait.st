"
I am a trait providing sample methods used as a fixture by the method-browser tests.

I define #sendMe and a #sender method that sends it, so tests can exercise
trait-based sender lookups. 
My user (StMethodBrowserDummyClass) inherits these methods.
"
Trait {
	#name : 'TSendersFixture',
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers-Tests'
}

{ #category : 'accessing' }
TSendersFixture >> sendMe [

	^ 2
]

{ #category : 'accessing' }
TSendersFixture >> sender [

	self sendMe
]
