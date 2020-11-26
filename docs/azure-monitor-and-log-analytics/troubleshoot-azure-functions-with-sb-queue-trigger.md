# Troubleshoot Azure Functions with Service Bus Queue Trigger
This article focuses on monitoring and troublshooting a Consumption Tier Azure Function with a Service Bus Queue trigger. 
The focus is to find out:

* if the Azure Function does activate even though the SB queue receives messages.
* notify if the function does not activates when it should.
* take automatic action to kick-start the function.

## Troubleshooting
These queries makes you follow the the life cycle of the Azure function. It produces a lot or rows if the timespan is long though. 

    let dtStart = datetime("yyyy-MM-dd hh:mm:ss"); 
    let dtEnd = datetime("yyyy-MM-dd hh:mm:ss");
    let sResource = "/<name of your azure function in capitals>"; // Ex "/AFTEST"
    let rowsLimit = 2000;
    FunctionAppLogs 
    | where TimeGenerated between (dtStart .. dtEnd)
    | where _ResourceId contains sResource
    | where (Category == "Host.Triggers.Warmup") or (Category == "Host.Startup" and Message startswith "Initializing Host")
        or (Category == "Microsoft.Azure.WebJobs.Hosting.OptionsLoggingService" and Message startswith "ServiceBusOptions")
        or (Category == "Microsoft.Azure.WebJobs.Hosting.JobHostService" and Message == "Starting JobHost")
        or (Category == "Host.Startup" and Message startswith "Starting Host")
        or (Category == "Host.Startup" and Message endswith "functions loaded")
        or (Category == "Host.Startup" and Message startswith "Found the following functions")
        or (Category == "Host.Startup" and Message startswith "Job host started")
        or (Category == "Microsoft.Azure.WebJobs.Hosting.JobHostService" and Message == "Stopping JobHost")
        or (Category == "Host.Startup" and Message startswith "Stopping the listener")
        or (Category == "Host.Startup" and Message == "Job host stopped")
    | union withsource=SourceTable kind=outer
        (AzureMetrics 
            | where TimeGenerated between (dtStart .. dtEnd)
            | where _ResourceId contains sResource
            | where MetricName == "MemoryWorkingSet"
            | project TimeGenerated, Category=Type, Message=tostring(Total))
    | order by TimeGenerated asc
    | limit rowsLimit

Same with relative time.

    let dtStart = ago(4h) 
    let sResource = "/<name of your azure function in capitals>"; // Ex "/AFTEST"
    let rowsLimit = 2000;
    FunctionAppLogs 
    | where TimeGenerated > dtStart
    | where _ResourceId contains sResource
    | where (Category == "Host.Triggers.Warmup") or (Category == "Host.Startup" and Message startswith "Initializing Host")
        or (Category == "Microsoft.Azure.WebJobs.Hosting.OptionsLoggingService" and Message startswith "ServiceBusOptions")
        or (Category == "Microsoft.Azure.WebJobs.Hosting.JobHostService" and Message == "Starting JobHost")
        or (Category == "Host.Startup" and Message startswith "Starting Host")
        or (Category == "Host.Startup" and Message endswith "functions loaded")
        or (Category == "Host.Startup" and Message startswith "Found the following functions")
        or (Category == "Host.Startup" and Message startswith "Job host started")
        or (Category == "Microsoft.Azure.WebJobs.Hosting.JobHostService" and Message == "Stopping JobHost")
        or (Category == "Host.Startup" and Message startswith "Stopping the listener")
        or (Category == "Host.Startup" and Message == "Job host stopped")
    | union withsource=SourceTable kind=outer
        (AzureMetrics 
            | where TimeGenerated > dtStart
            | where _ResourceId contains sResource
            | where MetricName == "MemoryWorkingSet"
            | project TimeGenerated, Category=Type, Message=tostring(Total))
    | order by TimeGenerated asc
    | limit rowsLimit

This query checks if the azure function is currently running or stopped, as well as returns the latest sign of life/sleep.

    let dtStart = ago(72h);
    let sResource = "/<name of your azure function in capitals>"; // Ex "/AFTEST"
    AzureMetrics 
    | where TimeGenerated > dtStart
    | where Total > 0
    | where _ResourceId contains sResource
    | where MetricName == "MemoryWorkingSet"
    | order by TimeGenerated desc
    | limit 1
    | project LatestAwakeLog=TimeGenerated, LatestAwakeLogAgo=(now()-TimeGenerated), _ResourceId
    | join (AzureMetrics 
        | where TimeGenerated > dtStart
        | where Total == 0.0
        | where _ResourceId contains sResource
        | where MetricName == "MemoryWorkingSet"
        | order by TimeGenerated desc
        | limit 1
        | project LatestSleepLog= TimeGenerated, LatestSleepLogAgo=(now()-TimeGenerated), _ResourceId)
        on _ResourceId
    | project LatestAwakeLog, LatestAwakeLogAgo, LatestSleepLog, LatestSleepLogAgo, State=iif(LatestAwakeLog > LatestSleepLog, "Running", "Stopped")

