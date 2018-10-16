# VC_Framework v15

## What's New?

* Forms are now exported! They are exported in JSON format and stored in a folder named "vc_forms".
* Your exported methods will be moved from "vc_source" to "vc_methods" to make things clearer.
* Advanced customization options are available for those that want them (but they are NOT necessary).
* Possibility to import outside changes (methods only). More see below.

## Description

The VC_Framework component facilitates automatic export of all methods and forms (collectively referred to as "assets") from a [4D](http://www.4d.com) host database to text files on disk.  If the host database is under revision control, these text files are suitable for committing to the repository, thus giving the developer a granular ability to track changes to assets over time. Most importantly, the VC_Framework component is designed to have zero impact on the host database.  There is no startup code to install and nothing to configure.

Methods are exported as plain text files.
Forms are exported as JSON text files.

Note: 4D v14 is REQUIRED.  Furthermore if you get errors about "unnamed" objects, you need at least 14.2.


## Contents

* The [Components](https://github.com/4D/vc-framework-v14/tree/master/Components) folder contains:
    * The "VC_Framework.4dbase" component suitable for installation in any [4D v14](http://www.4d.com/products/4dv14.html) database.
    * The "prog.4dbase" component, which extends 4D's Progress module to include a threshold for progress bar display. 
* The [matrix](https://github.com/4D/vc-framework-v14/tree/master/matrix) folder contains the component source code.


## Usage

Install the "VC_Framework.4dbase" component. Do NOT install an alias, you must install the component. Launch the host database in 4D, and open a method if none are open. This will launch the stored procedures to manage asset export.

(Optional) Install the "prog.4dbase" component. VC_Framework will not show progress bars without this component.

*Note: the first export may take some time in larger databases, but you only need to do this once.*

*Note: in a sufficiently complex database, VC_Framework may cause Design Mode to periodically hang. The component will detect this automatically and will let you know if it appears to be a problem.*


## Advanced Usage

### Activation at startup

Instead of waiting for VC_Framework to launch via method editor macros, you can install explicit startup code.  There is a macro for this; "VC_Framework: Startup Install".

#### Startup parameters

There are several configuration options that can be set during startup. This is useful if, for example, you want to disable form or method export (otherwise it will automatically start exporting). You pass these parameters in the form of a C_OBJECT.  These settings are persistent, so you only need to set them once.

These are the possible settings:

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| VC_DeleteIgnoreSlow | Boolean | False | Deletion detection can have a performance impact. This setting controls whether or not to ignore it. |
| VC_DeleteOnChange | Boolean | False | Only check for deleted methods if the database stamp has changed. |
| VC_DeleteProcDisabled | Boolean | False | Enable or disable the deletion detection process. |
| VC_DeleteProcDelay | Longint | 300 | Delay for the process that detects deleted methods. Measured in ticks. |
| VC_ExportForms | Boolean | True | Enable or disable form export. |
| VC_ExportMethods | Boolean | True | Enable or disable method export. |
| VC_ExportProcDelay | Longint | 60 | Delay for the process that detects changes and exports them. Measured in ticks. |
| VC_DeleteMGPThreshold | Longint | 100 | Deletion detection can have a performance impact. This setting controls the tolerance of that impact.  Default is 100 ms. |

For example, if you want to disable form export, add this to your On Startup database method:

	C_LONGINT($vc_found_l)
	ARRAY TEXT($vc_components_at;0)
	C_OBJECT($startupParams_o)
	OB SET($startupParams_o;"VC_ExportForms";False)
	COMPONENT LIST($vc_components_at)
	$vc_found_l:=Find in array($vc_components_at;"VC_Framework")
	If ($vc_found_l>0)
	EXECUTE METHOD("VC_STARTUP";*;$startupParams_o)
	End if 

### Deactivation at exit

If you do not have an On Exit or On server shutdown database method, I recommend creating one and adding a call to "VC_EXIT". This is NOT required, just recommended; it allows VC_Framework to exit gracefully.

### Process Management

The processes that handle exporting or deleting assets can be managed via macros. For example you can start or stop the process via macros. These macros are visible in your macros menus.

### Advanced configuration

#### Setters

There are several shared "setter" methods that allow you to tweak the component (methods named VC_CONFIG_@Set). Reminder: the component is open source, if you are interested in details for these settings, look at the source code to see what they do. Ideally the component should function without any tweaks (that's the goal). If you find you really need to change something, please [let me know](mailto:jfletcher@4d.com) because it might be that the default settings are wrong.

Here is a list of the setters:

(Hint: these control the same settings as the startup parameters described above)

| Method | Parameter Type | Description |
| --- | --- | --- |
| VC_CONFIG_DeleteIgnoreSlowSet | Boolean | Deletion detection can have a performance impact. This setting controls whether or not to ignore it. |
| VC_CONFIG_DeleteOnChangeSet | Boolean | Only check for deleted methods if the database stamp has changed. |
| VC_CONFIG_DeleteProcDisableSet | Boolean | Enable or disable the deletion detection process. |
| VC_CONFIG_DeleteProcDelaySet | Longint | Delay for the process that detects deleted methods. Measured in ticks. |
| VC_CONFIG_ExportFormsSet | Boolean | Enable or disable form export. |
| VC_CONFIG_ExportMethodsSet | Boolean | Enable or disable method export. |
| VC_CONFIG_ExportProcDelaySet | Longint | Delay for the process that detects changes and exports them. Measured in ticks. |
| VC_CONFIG_MGPThresholdSet | Longint | Deletion detection can have a performance impact. This setting controls the tolerance of that impact.  Default is 100 ms. |

#### Shared methods

Here us a list of the other shared methods:

| Method | Description |
| --- | --- |
| VC_DEBUG_BrowseVCDB | Allows you to browse the VC_Framework metadata stored in the VC_Data external database.
| VC_DEBUG_GetExtAssetData | Copy the asset metadata from the VC_Data external database to a text variable.
| VC_DELETE_ResolveError | When an error occurs at runtime, VC_Framework's process continue to run but in a disabled state. If you are able to resolve the error, you can run this method to enable the process again. This method can be called via a macro; in fact I recommend you just use the macro.
| VC_DELETE_Start | Start the deletion detection process. Use the macro to call this.
| VC_DELETE_Stop | Stop the deletion detection process. Use the macro to call this.
| VC_EXPORT_ResolveError | When an error occurs at runtime, VC_Framework's process continue to run but in a disabled state. If you are able to resolve the error, you can run this method to enable the process again. This method can be called via a macro; in fact I recommend you just use the macro.
| VC_EXPORT_Start | Start the export process. Use the macro to call this.
| VC_EXPORT_Stop | Stop the export process. Use the macro to call this.
| VC_Reset | Perform a full reset of VC_Framework, which will trigger a full export of everything.
| VC_STARTUP | Run the startup code.
| VC_STARTUP_MacroHandler | Called for method editor macros, automatically runs the startup code.

### RC Integration Hooks

The VC_Framework component can be extended to support basic revision control (RC) integration.  By this I mean that VC_Framework understands the concept of "create", "update" and "delete" for files.  If the host database (or another component) contains the following shared methods:

* VC_DEVHOOK_Create
* VC_DEVHOOK_Update
* VC_DEVHOOK_Delete

The VC_Framework component will call these methods prior to saving/deleting the method. The callee can choose whether or not to allow the change as well as take any action necessary to notify the RC software of the change.

The [VC_SVN](https://github.com/4D/vc-svn-v14) component is an example of this. VC_SVN will automatically execute the 'svn add' or 'svn delete' commands as appropriate.

## Import Outside Changes

Now it is possible to import changes made by other developers in your team. This works with edited methods and new methods. It does not work with 4D forms since there is no way to build forms with means of the 4D programming language.
These feature is useful if you want to do distributed team development and using a team development 4D server is not an appropriate way for you.

How does it work?
There is a new method **VCM_Import**. The method can be started using the macro call "Import methods". This triggers the import process. The import process looks for text files with newer or equal timestamp like the last import or the last changed method in 4D and shows a list with this found methods before you start the real import.

Some notes:

- Methods to be imported must not be opened in the design environment.
- Methods deleted outside of 4D will not be recognized. You have to delete them manually.

The recommended process:

1. Close all your methods in 4D.
2. Open only one method. Make sure this method isn't changed after the last edit of methods in your 4D structure.
2. Checkout the changes from your co-developers e.g. using a source code versioning system like git or mercurial or every other way you aware of.
2. Trigger the import using the macro "Import methods".
3. Confirm the dialog showing the files to be imported.
3. Ready! You should check the success of the import process doing a re-compile of your 4D structure.

