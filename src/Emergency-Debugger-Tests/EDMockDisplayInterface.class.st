"
I am a null display interface for testing the Ed debugger.
I catch all message through DNU and just do nothing.
"
Class {
	#name : #EDMockDisplayInterface,
	#superclass : #Object,
	#category : #'Emergency-Debugger-Tests'
}

{ #category : #'reflective operations' }
EDMockDisplayInterface >> doesNotUnderstand: aMessage [
	
	"self inform: 'Ed display: ', aMessage printString"
]
