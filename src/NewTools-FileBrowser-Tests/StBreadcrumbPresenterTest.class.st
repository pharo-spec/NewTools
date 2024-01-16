Class {
	#name : 'StBreadcrumbPresenterTest',
	#superclass : 'StFileBrowserTestCase',
	#instVars : [
		'windowPathUI'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'running' }
StBreadcrumbPresenterTest >> setUp [
	super setUp.
	windowPathUI := StPathBreadcrumbPresenter 
		owner: fileSystemPresenter 
		on: fileSystemModel
]

{ #category : 'running' }
StBreadcrumbPresenterTest >> tearDown [
	windowPathUI withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : 'tests' }
StBreadcrumbPresenterTest >> testRoot [

	windowPathUI currentDirectory: FileLocator root.
	windowPathUI open.
	self assert: windowPathUI path presenters size equals: 1
]
