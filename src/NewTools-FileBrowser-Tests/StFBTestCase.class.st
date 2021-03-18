Class {
	#name : #StFBTestCase,
	#superclass : #TestCase,
	#instVars : [
		'root'
	],
	#category : #'NewTools-FileBrowser-Tests-UI'
}

{ #category : #testing }
StFBTestCase class >> isAbstract [
	^ self = StFBTestCase
]

{ #category : #accessing }
StFBTestCase class >> resources [
	^ {StFBFileSystemResource}
]

{ #category : #testing }
StFBTestCase class >> shouldInheritSelectors [
	^ true
]

{ #category : #'instance creation' }
StFBTestCase >> inspectRoot [
	<script: 'self basicNew createRoot asFileReference inspect'>
	
]

{ #category : #running }
StFBTestCase >> setUp [
	super setUp.
	root := StFBFileSystemResource current root
]
