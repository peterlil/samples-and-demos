# Troubleshoot Azure Functions with Service Bus Queueu Trigger
This article focuses on monitoring and troublshooting a Consumption Tier Azure Function with a Service Bus Queue trigger. 
The focus is to find out:

* if the Azure Function does activate even though the SB queue receives messages.
* notify if the function does not activates when it should.
* take automatic action to kick-start the function.