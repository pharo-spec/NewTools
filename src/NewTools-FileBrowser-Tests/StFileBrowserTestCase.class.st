Class {
	#name : 'StFileBrowserTestCase',
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
StFileBrowserTestCase class >> isAbstract [
	^ self = StFileBrowserTestCase
]

{ #category : 'accessing' }
StFileBrowserTestCase class >> resources [
	^ {StFileSystemResource}
]

{ #category : 'testing' }
StFileBrowserTestCase class >> shouldInheritSelectors [
	^ true
]

{ #category : 'instance creation' }
StFileBrowserTestCase >> inspectRoot [
	<script: 'self basicNew createRoot asFileReference inspect'>
	
]

{ #category : 'running' }
StFileBrowserTestCase >> setUp [

	super setUp.
	fileSystemModel := StFileSystemModel new.
	fileSystemPresenter := StFileSystemPresenter on: fileSystemModel.
	root := StFileSystemResource current root
]
