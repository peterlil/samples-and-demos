using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;


using Microsoft.Azure.EventGrid.Models;

// NuGet required: https://www.nuget.org/packages/Microsoft.Azure.EventGrid/
// dotnet add package Microsoft.Azure.EventGrid --version 3.2.0

namespace Peterlabs.Samples.Function
{
    
    public static class EgsPublisher
    {
        [FunctionName("EgsPublisher")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function is preparing a custom Event Grid event.");
            
            string traceId = Guid.NewGuid().ToString();
            var testEvent = new EventGridEvent()
            {
                Id = Guid.NewGuid().ToString(),
                Subject = "My custom event",
                EventType = "my-customer-event-type",
                EventTime = DateTime.UtcNow,
                Data = traceId,
                DataVersion = "1.0"
            };

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            
            string responseMessage = "";

            return new OkObjectResult(responseMessage);
        }
    }
}
