"
Publish the content of a page in [http://ws.stfx.eu](http://ws.stfx.eu)
"
Class {
	#name : 'StPlaygroundPublishCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'default' }
StPlaygroundPublishCommand class >> defaultDescription [

	^  'Publish contents to the cloud.'
]

{ #category : 'accessing' }
StPlaygroundPublishCommand class >> defaultIconName [

	^ #saveToUrl
]

{ #category : 'default' }
StPlaygroundPublishCommand class >> defaultName [

	^ 'Publish'
]

{ #category : 'accessing' }
StPlaygroundPublishCommand class >> order [

	^ 5
]

{ #category : 'accessing' }
StPlaygroundPublishCommand class >> urlProvider [

	^ 'http://ws.stfx.eu' asZnUrl
]

{ #category : 'execution' }
StPlaygroundPublishCommand >> execute [

	| contents publishedUrl |
	(self application confirm: 'Publish playground content to the cloud?')
		ifFalse: [ ^ self ].

	contents := self page contents.
	contents ifEmpty: [
		self application inform:
			'Nothing was published because the playground is empty'.
		^ self ].

	Clipboard clipboardText:
		(publishedUrl := (self post: contents) asString).
	self application inform:
		publishedUrl , ' was published and the url was copied to clipboard'
]

{ #category : 'accessing' }
StPlaygroundPublishCommand >> page [

	^ context page
]

{ #category : 'public' }
StPlaygroundPublishCommand >> post: aString [
	| response url |

	response := ZnClient new
		systemPolicy;
		beOneShot;
		accept: ZnMimeType textPlain;
		url: self class urlProvider;
		entity: (ZnEntity text: aString);
		post;
		response.
		
	url := response location.
	^ url asZnUrl inContextOf: self class urlProvider
]
