Class {
	#name : #FDWindowPathPresenterTest,
	#superclass : #FDTestCase,
	#instVars : [
		'windowPathUI'
	],
	#category : #'NewTools-FileDialog-Tests-UI'
}

{ #category : #running }
FDWindowPathPresenterTest >> setUp [
	super setUp.
	windowPathUI := FDWindowPathPresenter new
]

{ #category : #running }
FDWindowPathPresenterTest >> tearDown [
	windowPathUI withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
FDWindowPathPresenterTest >> testRoot [
	windowPathUI currentDirectory: FileLocator root.
	windowPathUI openWithSpec.
	self assert: windowPathUI path presenters size equals: 1
]
