Class {
	#name : 'StFBTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'root',
		'fileSystemModel',
		'fileSystemPresenter'
	],
	#category : 'NewTools-FileBrowser-Tests-UI',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'UI'
}

{ #category : 'testing' }
StFBTestCase class >> isAbstract [
	^ self = StFBTestCase
]

{ #category : 'accessing' }
StFBTestCase class >> resources [
	^ {StFBFileSystemResource}
]

{ #category : 'testing' }
StFBTestCase class >> shouldInheritSelectors [
	^ true
]

{ #category : 'instance creation' }
StFBTestCase >> inspectRoot [
	<script: 'self basicNew createRoot asFileReference inspect'>
	
]

{ #category : 'running' }
StFBTestCase >> setUp [

	super setUp.
	fileSystemModel := StFBFileSystemModel new.
	fileSystemPresenter := StFBFileSystemPresenter on: fileSystemModel.
	root := StFBFileSystemResource current root
]
