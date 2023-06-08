"
A Mock class to deterministically perform tests instead on relying on the system clock and process scheduler's grace.
When wait is called on this object from a secondary thread (<=IMPORTANT), it will be blocked until the resume method is called or its timeout(default 500 ms) is reached.

This is essentially a Semaphore, with a built-in timeout and specific for these kind of tests.
"
Class {
	#name : #StPlaygroundPageTestMockedWaitable,
	#superclass : #Object,
	#instVars : [
		'sem',
		'sem2',
		'timeout'
	],
	#category : #'NewTools-Playground-Tests'
}

{ #category : #initialization }
StPlaygroundPageTestMockedWaitable >> initialize [

	sem := Semaphore new.
	sem2 := Semaphore new.
	timeout := 500
]

{ #category : #accessing }
StPlaygroundPageTestMockedWaitable >> resume [

	sem signal.
	^ sem2 wait: (Duration milliSeconds: timeout)
]

{ #category : #accessing }
StPlaygroundPageTestMockedWaitable >> timeout: aNumberMiliseconds [

	timeout := aNumberMiliseconds
]

{ #category : #accessing }
StPlaygroundPageTestMockedWaitable >> wait [

	| semRes |
	semRes := sem wait: (Duration milliSeconds: timeout).
	sem2 signal.
	^ semRes
]
