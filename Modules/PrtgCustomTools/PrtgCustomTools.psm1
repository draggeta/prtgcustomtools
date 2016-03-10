Function Create-PrtgResult {

    <# 
    .SYNOPSIS 
       Creates PRTG results. 
    .DESCRIPTION 
        Takes specified values and creates the XML needed for each channel in a PRTG custom EXE/Script Advanced sensor.
    .PARAMETER Channel
        Name of the channel as displayed in user interfaces. This parameter is required and must be unique for the sensor.
    .PARAMETER Value
        The value as integer or float. Please make sure the Float parameter matches the kind of value provided. Otherwise PRTG will show 0 values.
    .PARAMETER Unit
        The unit of the value. Default is Custom. Useful for PRTG to be able to convert volumes and times.
    .PARAMETER CustomUnit
        If Custom is used as unit this is the text displayed behind the value.
    .PARAMETER SpeedSize/VolumeSize
        Size used for the display value. E.g. if you have a value of 50000 and use Kilo as size the display is 50 kilo #. Default is One (value used as returned). For the Bytes and Speed units this is overridden by the setting in the user interface.
    .PARAMETER SpeedTime
        See above, used when displaying the speed. Default is Second.
    .PARAMETER Mode
        Selects if the value is a absolute value or counter. Default is Absolute.
    .PARAMETER Float
        Define if the value is a float. Default is 0 (no). If set to 1 (yes), use a dot as decimal separator in values. Note: Define decimal places with the DecimalMode parameter.
    .PARAMETER DecimalMode
        Init value for the Decimal Places option. If 0 is used in the Float parameter (i.e. use integer), the default is Auto; otherwise (i.e. for float) default is All. Note: You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER Warning
        If enabled for at least one channel, the entire sensor is set to warning status. Default is 0 (no).
    .PARAMETER ShowChart
        Init value for the Show in Chart option. Default is 1 (yes). Note: The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER ShowTable
        Init value for the Show in Table option. Default is 1 (yes). Note: The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER LimitMaxError
        Define an upper error limit for the channel. If enabled, the sensor will be set to a "Down" status if this value is overrun and the LimitMode is activated. Note: Please provide the limit value in the unit of the base data type, just as used in the Value parameter of this section. While a sensor shows a "Down" status triggered by a limit, it will still receive data in its channels. The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER LimitMaxWarning
        Define an upper warning limit for the channel. If enabled, the sensor will be set to a "Warning" status if this value is overrun and the LimitMode is activated. Note: Please provide the limit value in the unit of the base data type, just as used in the Value parameter of this section. The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER LimitMinWarning
        Define a lower warning limit for the channel. If enabled, the sensor will be set to a "Warning" status if this value is undercut and the LimitMode is activated. Note: Please provide the limit value in the unit of the base data type, just as used in the Value parameter of this section. The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER LimitMinError
        Define a lower error limit for the channel. If enabled, the sensor will be set to a "Down" status if this value is undercut and the LimitMode is activated. Note: Please provide the limit value in the unit of the base data type, just as used in the Value parameter of this section. While a sensor shows a "Down" status triggered by a limit, it will still receive data in its channels. The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER LimitErrorMsg
        Define an additional message. It will be added to the sensor's message when entering a "Down" status that is triggered by a limit. Note: The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER LimitWarningMsg
        Define an additional message. It will be added to the sensor's message when entering a "Warning" status that is triggered by a limit. Note: The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER LimitMode
        Define if the limit settings defined above will be active. Default is 0 (no; limits inactive). If 0 is used the limits will be written to the sensor channel settings as predefined values, but limits will be disabled. Note: This setting will be considered only on the first sensor scan, when the channel is newly created; it is ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER ValueLookup
        Define if you want to use a lookup file (e.g. to view integer values as status texts). Please enter the ID of the lookup file you want to use, or omit this element to not use lookups. Note: This setting will be considered only on the first sensor scan, when the channel is newly created; it is ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the Channel settings of the sensor.
    .PARAMETER NotifyChanged
        If a returned channel contains this tag, it will trigger a change notification that you can use with the Change Trigger to send a notification.
    .EXAMPLE 
        Create-PrtgResult -Parameter
        Description 
         
        ----------- 
     
        Some Text.
    .EXAMPLE 
        Create-PrtgResult -Parameter
        Description 
         
        ----------- 
     
        Some Text.
    .EXAMPLE 
        Create-PrtgResult -Parameter
        Description 
         
        ----------- 
     
        Some Text.
    .INPUTS 
    	None. You cannot pipe objects to Send-PasswordExpirationMail.ps1 
    .OUTPUTS 
    	None. Send-PasswordExpirationMail.ps1 only outputs to the EventLog 
    .NOTES 
        Author:   Tony Fortes Ramos 
        Created:  March 07, 2016
        Modified: March 07, 2016 
    .LINK 
    	Cmdlet
        Cmdlet
        Cmdlet
        Cmdlet 
    #>

    [CmdletBinding(DefaultParameterSetName = 'VolumeSize')]
    Param
    (

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]$Channel,
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $Value,
        [ValidateSet('BytesBandwidth','BytesMemory','BytesDisk','Temperature','Percent','TimeResponse','TimeSeconds','Custom','Count','CPU','BytesFile','SpeedDisk','SpeedNet','TimeHours')]
        [String]$Unit = 'Custom',
        [String]$CustomUnit,
        [ValidateSet('One','Kilo','Mega','Giga','Tera','Byte','KiloByte','MegaByte','GigaByte','TeraByte','Bit','KiloBit','MegaBit','GigaBit','TeraBit')]
        [String]$VolumeSize,
        [ValidateSet('One','Kilo','Mega','Giga','Tera','Byte','KiloByte','MegaByte','GigaByte','TeraByte','Bit','KiloBit','MegaBit','GigaBit','TeraBit')]
        [String]$SpeedSize,
        [ValidateSet('Second','Minute','Hour','Day')]
        [String]$SpeedTime,
        [ValidateSet('Absolute','Difference')]
        [String]$Mode = 'Absolute',
        [ValidateSet(0,1)]
        [String]$Float = 0,
        [ValidateSet('Auto','All')]
        [String]$DecimalMode,
        [ValidateSet(0,1)]
        [String]$Warning = 0,
        [ValidateSet(0,1)]
        [String]$ShowChart = 1,
        [ValidateSet(0,1)]
        [String]$ShowTable = 1,
        [Int]$LimitMaxError,
        [Int]$LimitMaxWarning,
        [Int]$LimitMinWarning,
        [Int]$LimitMinError,
        [String]$LimitErrorMsg,
        [String]$LimitWarningMsg,
        [ValidateSet(0,1)]
        [String]$LimitMode = 0,
        [String]$ValueLookup,
        [Switch]$NotifyChanged

    )
        
    Begin {

        $Results = "<result>"

    }
    Process {

        $Results += "<channel>$Channel</channel><value>$Value</value><unit>$Unit</unit><mode>$Mode</mode><float>$Float</float><warning>$Warning</warning><showchart>$ShowChart</showchart><showtable>$ShowTable</showtable><limitmode>$LimitMode</limitmode>"

        If ($CustomUnit){
            $Results += "<customunit>$CustomUnit</customunit>"   
        }
        If ($VolumeSize){
            $Results += "<volumesize>$VolumeSize</volumesize>"
        }
        If ($SpeedSize){
            $Results += "<speedsize>$SpeedSize</speedsize>"
        }
        If ($SpeedTime){
            $Results += "<speedtime>$SpeedTime</speedtime>"
        }
        If ($DecimalMode){
            $Results += "<decimalmode>$DecimalMode</decimalmode>"
        }
        If ($LimitMaxError){
            $Results += "<limitmaxerror>$LimitMaxError</limitmaxerror>"   
        }
        If ($LimitMaxWarning){
            $Results += "<limitmaxwarning>$LimitMaxWarning</limitmaxwarning>"   
        }
        If ($LimitMinWarning){
            $Results += "<limitminwarning>$LimitMinWarning</limitminwarning>"   
        }
        If ($LimitMinError){
            $Results += "<limitminerror>$LimitMinError</limitminerror>"   
        }
        If ($LimitErrorMsg){
            $Results += "<limiterrormsg>$LimitErrorMsg</limiterrormsg>"   
        }
        If ($LimitWarningMsg){
            $Results += "<limitwarningmsg>$LimitWarningMsg</limitwarningmsg>"   
        }
        If ($ValueLookup){
            $Results += "<valuelookup>$ValueLookup</valuelookup>"   
        }
        If ($NotifyChanged){
            $Results += "<notifychanged></notifychanged>"   
        }

    }
    End {

        $Results += "</result>"
        $Results

    }

}

Function Publish-PrtgResult {

    <# 
    .SYNOPSIS
        Publishes PRTG results. 
    .DESCRIPTION
        Takes specified results and creates the XML needed for a PRTG custom EXE/Script Advanced sensor.
    .PARAMETER Publish
        Name of the result(s) that will be published in XML-form suited for PRTG. This parameter is required.
    .PARAMETER Text
        Text the sensor returns in the Message field with every scanning interval. There can be one message per sensor, regardless of the number of channels. Default is OK. Maximum length is 2000 characters.
    .PARAMETER Error
        If enabled, the sensor will return an error status. This element can be combined with the Text parameter in order to show an error message. Default is 0. Note: A sensor in this error status cannot return any data in its channels; if used, all channel values in the sensor will be ignored.
    .EXAMPLE
        Publish-PrtgResult -Parameter
        Description 
         
        ----------- 
     
        Some Text.
    .EXAMPLE
        Publish-PrtgResult -Parameter
        Description 
         
        ----------- 
     
        Some Text.
    .EXAMPLE
        Publish-PrtgResult -Parameter
        Description 
         
        ----------- 
     
        Some Text.
    .INPUTS
    	From pipeline.
    .OUTPUTS
    	None.
    .NOTES
        Author:   Tony Fortes Ramos 
        Created:  March 07, 2016
        Modified: March 07, 2016 
    .LINK 
    	Cmdlet
        Cmdlet
        Cmdlet
        Cmdlet 
    #>   
     
    [CmdletBinding()]
    Param
    (

        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Publish,
        [String]$Text = 'OK',
        [ValidateSet(0,1)]
        [String]$Error = 0

    )

    Begin {

        $PublishedResult = "<?xml version=`"1.0`"?><prtg>"

    }

    Process { 
     
        $PublishedResult += $Publish

        If ($Text){
            $PublishedResult += "<text>$Text</text>"   
        }

        If ($Error){
            $PublishedResult += "<error>$Error</error>"   
        }
    
    }
    End {
    
        $PublishedResult += "</prtg>"
        $PublishedResult

    }

}