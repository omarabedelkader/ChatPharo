"
First-launch setup wizard for ChatPharo.
* Shows when ChatPharo is first installed or settings are not configured
* Asks for developer ID to verify if user is an authorized developer
* If not a developer, collects basic user information (name, organization)
* Saves configuration to ChatPharoSettings
* **Why** – provides a friendly onboarding experience and developer verification.
```smalltalk
ChatPharoSetupPresenter open.
ChatPharoSetupPresenter openIfNeeded.
"
Class {
	#name : 'ChatPharoSetupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'titleLabel',
		'descriptionLabel',
		'developerIdInput',
		'verifyButton',
		'skipDeveloperButton',
		'userNameInput',
		'userOrganizationInput',
		'saveButton',
		'cancelButton',
		'statusLabel',
		'currentStep',
		'contentContainer',
		'isDeveloperVerified'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo-Spec'
}

{ #category : 'instance creation' }
ChatPharoSetupPresenter class >> open [
	"Open the setup wizard."

	^ self new open
]

{ #category : 'instance creation' }
ChatPharoSetupPresenter class >> openIfNeeded [
	"Open the setup wizard only if not already configured."

	ChatPharoSettings default isConfigured ifFalse: [
		^ self open ].
	^ nil
]

{ #category : 'instance creation' }
ChatPharoSetupPresenter >> cancelSetup [
	"Cancel the setup without saving. Mark as configured to prevent repeated prompts."

	| settings |
	settings := ChatPharoSettings default.
	settings isConfigured: true.
	self window close
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 16;
		borderWidth: 20;
		add: titleLabel expand: false;
		add: descriptionLabel expand: false;
		add: contentContainer expand: true;
		add: statusLabel expand: false;
		yourself
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> initialize [

	super initialize.
	currentStep := #developer.
	isDeveloperVerified := false
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> initializePresenters [

	super initializePresenters.

	titleLabel := self newLabel
		label: 'Welcome to ChatPharo';
		yourself.

	descriptionLabel := self newLabel
		label: 'Let''s set up your profile. Are you a ChatPharo developer?';
		yourself.

	statusLabel := self newLabel
		label: '';
		yourself.

	contentContainer := SpBoxLayout newTopToBottom
		spacing: 12;
		yourself.

	self showDeveloperStep
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'ChatPharo Setup';
		initialExtent: 500@400;
		centered
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> saveUserConfiguration [
	"Save the user configuration and close the wizard."

	| settings |
	settings := ChatPharoSettings default.

	userNameInput text trimBoth ifNotEmpty: [ :name |
		settings userName: name ].

	userOrganizationInput text trimBoth ifNotEmpty: [ :org |
		settings userOrganization: org ].

	settings isDeveloper: isDeveloperVerified.
	settings isConfigured: true.

	ChatPharoLogger logSystem: 'User configuration completed'
		details: (Dictionary new
			at: 'isDeveloper' put: isDeveloperVerified;
			at: 'hasName' put: settings userName isNotEmpty;
			at: 'hasOrganization' put: settings userOrganization isNotEmpty;
			yourself).

	self inform: 'Configuration saved successfully!'.
	self window close
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> showDeveloperStep [
	"Show the developer verification step."

	| idRow buttonRow |
	currentStep := #developer.

	descriptionLabel label: 'Do you have a ChatPharo Developer ID?'.
	statusLabel label: ''.

	developerIdInput := self newTextInput
		placeholder: 'Enter your Developer ID...';
		yourself.

	verifyButton := self newButton
		label: 'Verify ID';
		icon: (self iconNamed: #glamorousGo);
		action: [ self verifyDeveloperId ];
		yourself.

	skipDeveloperButton := self newButton
		label: 'Skip (I''m not a developer)';
		action: [ self showUserInfoStep ];
		yourself.

	cancelButton := self newButton
		label: 'Cancel';
		action: [ self cancelSetup ];
		yourself.

	idRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: developerIdInput expand: true;
		add: verifyButton expand: false;
		yourself.

	buttonRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: skipDeveloperButton expand: false;
		add: cancelButton expand: false;
		yourself.

	contentContainer removeAll.
	contentContainer
		add: idRow expand: false;
		add: buttonRow expand: false.

	self layout: self defaultLayout
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> showUserInfoStep [
	"Show the user information collection step."

	| nameRow orgRow buttonRow infoLabel |
	currentStep := #userInfo.

	isDeveloperVerified
		ifTrue: [
			descriptionLabel label: 'Developer verified! Please provide your details.' ]
		ifFalse: [
			descriptionLabel label: 'Please tell us a bit about yourself (optional).' ].

	statusLabel label: ''.

	infoLabel := self newLabel
		label: 'This information helps personalize your ChatPharo experience.';
		yourself.

	userNameInput := self newTextInput
		placeholder: 'Your name...';
		text: ChatPharoSettings default userName;
		yourself.

	userOrganizationInput := self newTextInput
		placeholder: 'Organization/Company (optional)...';
		text: ChatPharoSettings default userOrganization;
		yourself.

	saveButton := self newButton
		label: 'Save & Continue';
		icon: (self iconNamed: #glamorousAccept);
		action: [ self saveUserConfiguration ];
		yourself.

	cancelButton := self newButton
		label: 'Cancel';
		action: [ self cancelSetup ];
		yourself.

	nameRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: (self newLabel label: 'Name:') expand: false;
		add: userNameInput expand: true;
		yourself.

	orgRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: (self newLabel label: 'Organization:') expand: false;
		add: userOrganizationInput expand: true;
		yourself.

	buttonRow := SpBoxLayout newHorizontal
		spacing: 8;
		add: saveButton expand: false;
		add: cancelButton expand: false;
		yourself.

	contentContainer removeAll.
	contentContainer
		add: infoLabel expand: false;
		add: nameRow expand: false;
		add: orgRow expand: false;
		add: buttonRow expand: false.

	self layout: self defaultLayout
]

{ #category : 'layout' }
ChatPharoSetupPresenter >> verifyDeveloperId [
	"Verify the entered developer ID against the remote list."

	| enteredId |
	enteredId := developerIdInput text trimBoth.

	enteredId isEmpty ifTrue: [
		statusLabel label: 'Please enter a Developer ID.'.
		^ self ].

	statusLabel label: 'Verifying...'.
	verifyButton enabled: false.

	[
		| isValid settings |
		isValid := ChatPharoDeveloperConfig verifyDeveloperId: enteredId.

		self defer: [
			verifyButton enabled: true.
			isValid
				ifTrue: [
					isDeveloperVerified := true.
					settings := ChatPharoSettings default.
					settings developerId: enteredId.
					settings isDeveloper: true.
					statusLabel label: 'Developer ID verified successfully!'.
					self showUserInfoStep ]
				ifFalse: [
					statusLabel label: 'Invalid Developer ID. Please try again or skip.' ]
		]
	] fork
]
