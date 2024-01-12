Class {
	#name : 'StFBBreadcrumbPresenterTest',
	#superclass : 'StFBTestCase',
	#instVars : [
		'windowPathUI'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'running' }
StFBBreadcrumbPresenterTest >> setUp [
	super setUp.
	windowPathUI := StFBPathBreadcrumbPresenter new
]

{ #category : 'running' }
StFBBreadcrumbPresenterTest >> tearDown [
	windowPathUI withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : 'tests' }
StFBBreadcrumbPresenterTest >> testRoot [

	windowPathUI currentDirectory: FileLocator root.
	windowPathUI open.
	self assert: windowPathUI path presenters size equals: 1
]
