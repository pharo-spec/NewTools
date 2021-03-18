Class {
	#name : #StFBWindowPathPresenterTest,
	#superclass : #StFBTestCase,
	#instVars : [
		'windowPathUI'
	],
	#category : #'NewTools-FileBrowser-Tests-UI'
}

{ #category : #running }
StFBWindowPathPresenterTest >> setUp [
	super setUp.
	windowPathUI := StFBWindowPathPresenter new
]

{ #category : #running }
StFBWindowPathPresenterTest >> tearDown [
	windowPathUI withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
StFBWindowPathPresenterTest >> testRoot [
	windowPathUI currentDirectory: FileLocator root.
	windowPathUI openWithSpec.
	self assert: windowPathUI path presenters size equals: 1
]
